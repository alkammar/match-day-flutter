import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:match_day/bloc/edit_profile/bloc.dart';
import 'package:match_day/repo/profile_repository.dart';
import 'package:match_day/ui/main_button.dart';
import 'package:match_day/ui/md_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();

  static Route route() {
    return MaterialPageRoute(builder: (context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<EditProfileBloc>(
              create: (context) => EditProfileBloc(
                    profileRepository:
                        RepositoryProvider.of<ProfileRepository>(context),
                  )),
        ],
        child: EditProfileScreen(),
      );
    });
  }
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<EditProfileBloc, EditProfileState>(
          builder: (BuildContext context, state) {
            return Text(
                state.original == null ? 'Create Profile' : 'Edit Profile');
          },
        ),
      ),
      body: SafeArea(
        child: BlocListener<EditProfileBloc, EditProfileState>(
          listener: (context, state) {
            if (state.status == EditStatus.complete) Navigator.pop(context);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<EditProfileBloc, EditProfileState>(
                      buildWhen: (previous, current) =>
                          previous.status == EditStatus.uninitialized,
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MdTextField(
                            label: AppLocalizations.of(context).matchDayName,
                            text: '${state.original?.name}',
                            onChanged: (text) {
                              BlocProvider.of<EditProfileBloc>(context)
                                  .add(EditName(text));
                            },
                          ),
                        );
                      }),
                ],
              ),
              BlocBuilder<EditProfileBloc, EditProfileState>(
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: MainButton(
                        onPressed: state.status == EditStatus.edited
                            ? () => BlocProvider.of<EditProfileBloc>(context)
                                .add(SubmitEdits())
                            : null,
                        loading: state.status == EditStatus.submitting,
                        label: state.original == null ? 'Create' : 'Edit',
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
