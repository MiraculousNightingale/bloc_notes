import 'package:bloc_notes/models/note/note_failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/notes_bloc.dart';
import '../../models/note/note.dart';
import 'note_list_screen.dart';

class NoteFormScreen extends StatefulWidget {
  static const subPath = 'form';
  static const path = '${NoteListScreen.path}/$subPath';

  final Note? initialValue;

  const NoteFormScreen({
    super.key,
    this.initialValue,
  });

  bool get isCreateMode => initialValue == null;

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  late final TextEditingController titleController;
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(
      text: widget.initialValue?.text,
    );
    textController = TextEditingController(
      text: widget.initialValue?.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotesBloc, NotesState>(
      listenWhen: (previous, current) {
        // Check if state transitioned through the creation process
        return previous.isCreating && !current.isCreating;
      },
      listener: (context, state) {
        // TODO: is there a better way to handle errors?
        final error = state.getError<NotesCreateFailure>();
        if (error != null) {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          scaffoldMessenger.hideCurrentSnackBar();
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Something went wrong. ${error.message}')),
          );
          context.read<NotesBloc>().add(NotesErrorHandled(error));
          return;
        }

        context.go(NoteListScreen.path);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.isCreateMode ? 'Create' : 'Update'} Note'),
          actions: [
            BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) {
                if (state.isCreating) {
                  return const CircularProgressIndicator();
                }
                return IconButton(
                  onPressed: () {
                    context.read<NotesBloc>().add(
                          NotesCreated(
                            newNote: Note(
                              title: titleController.text,
                              text: textController.text,
                            ),
                          ),
                        );
                  },
                  icon: const Icon(Icons.check),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      label: const Text('Title'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: textController,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    maxLines: 10,
                    decoration: InputDecoration(
                      label: const Text('Text'),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
