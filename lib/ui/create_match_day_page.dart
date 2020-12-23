import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_day/bloc/create_match_day/bloc.dart';
import 'package:match_day/bloc/edit_match_day/bloc.dart';
import 'package:match_day/model/match_day.dart';
import 'package:match_day/ui/main_button.dart';
import 'package:match_day/ui/md_text_field.dart';

class CreateMatchDayPage extends StatefulWidget {
  final MatchDay matchDay;

  @override
  _CreateMatchDayPageState createState() => _CreateMatchDayPageState();

  CreateMatchDayPage({this.matchDay});
}

class _CreateMatchDayPageState extends State<CreateMatchDayPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.matchDay == null) {
      BlocProvider.of<CreateMatchDayBloc>(context).add(CreateMatchDay());
    } else {
      BlocProvider.of<EditMatchDayBloc>(context).add(LoadMatchDay(widget.matchDay));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.matchDay == null ? 'Create Match Day' : 'Edit Match Day'),
      ),
      body: SafeArea(
        child: BlocListener<EditMatchDayBloc, EditMatchDayState>(
          listener: (context, state) {
            if (state.status == EditStatus.complete) Navigator.pop(context);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<EditMatchDayBloc, EditMatchDayState>(
                      buildWhen: (previous, current) => previous.status == EditStatus.uninitialized,
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MdTextField(
                            label: 'Match Day Name',
                            text: '${state.original?.name}',
                            onChanged: (text) {
                              BlocProvider.of<EditMatchDayBloc>(context).add(EditName(text));
                            },
                          ),
                        );
                      }),
                  BlocBuilder<EditMatchDayBloc, EditMatchDayState>(builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${state.original?.admin?.name}'),
                    );
                  }),
                  BlocBuilder<EditMatchDayBloc, EditMatchDayState>(
                      buildWhen: (previous, current) => previous.status == EditStatus.uninitialized,
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MdTextField(
                            label: 'Match Day Location',
                            text: '${state.original?.location}',
                            onChanged: (text) {
                              BlocProvider.of<EditMatchDayBloc>(context).add(EditLocation(text));
                            },
                          ),
                        );
                      }),
                  SizedBox(
                    width: double.infinity,
                    child: MainButton(
                      loading: false,
                      // onPressed: () => BlocProvider.of<EditMatchDayBloc>(context).add(),
                      label: 'Add Player',
                    ),
                  ),
                ],
              ),
              BlocBuilder<EditMatchDayBloc, EditMatchDayState>(
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: MainButton(
                        onPressed: state.status == EditStatus.edited
                            ? () => BlocProvider.of<EditMatchDayBloc>(context).add(SubmitEdits())
                            : null,
                        loading: state.status == EditStatus.submitting,
                        label: 'Submit',
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
