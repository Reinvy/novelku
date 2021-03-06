import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:novelku/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../view_models/novel_view_model.dart';
import '../../view_models/publish_view_model.dart';

class PostChapterView extends StatelessWidget {
  const PostChapterView({Key? key}) : super(key: key);
  static String routeName = '/post_chapter';

  @override
  Widget build(BuildContext context) {
    var publishViewModel = Provider.of<PublishViewModel>(context);
    var novelViewModel = Provider.of<NovelViewModel>(context);
    var authViewModel = Provider.of<AuthViewModel>(context);
    var judulController = TextEditingController();
    var contentController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    String idNovel = ModalRoute.of(context)?.settings.arguments as String;

    return SafeArea(
      child: Scaffold(
        backgroundColor: colorPrimary1,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 25, right: 25, bottom: 20),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Upload Chapter',
                      style: GoogleFonts.comfortaa(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: judulController,
                    decoration: InputDecoration(
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 3),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      hintText: "Masukan Judul Chapter",
                      labelText: "Judul Chapter",
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silahkan masukan judul';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    maxLines: 20,
                    controller: contentController,
                    decoration: InputDecoration(
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 3),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      hintText: "Masukan Content",
                      alignLabelWithHint: true,
                      labelText: "Content",
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silahkan masukan isi content';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await publishViewModel.postChapter(idNovel,
                          judulController.text, contentController.text);
                      Navigator.pop(context);
                      await Future.delayed(
                        const Duration(
                          milliseconds: 500,
                        ),
                      );
                      await novelViewModel.init();
                      novelViewModel.updateMyNovels(authViewModel.user.nama);
                    },
                    child: const Text('Upload Chapter'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
