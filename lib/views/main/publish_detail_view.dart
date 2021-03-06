import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../view_models/publish_view_model.dart';
import '../../view_models/novel_view_model.dart';
import '../main/chapter_view.dart';
import '../main/post_chapter_view.dart';

class PublishDetailView extends StatelessWidget {
  static String routeName = '/publish_detail';
  const PublishDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final novelViewModel = Provider.of<NovelViewModel>(context);
    final publishViewModel = Provider.of<PublishViewModel>(context);

    String keyNovel = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as String;
    int idNovel =
        novelViewModel.novels.indexWhere((element) => element.id == keyNovel);
    var chapter = novelViewModel.novels[idNovel].chapter;

    return SafeArea(
      child: Scaffold(
        backgroundColor: colorPrimary1,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        colorPrimary2.withOpacity(0.5), BlendMode.dstATop),
                    image:
                        NetworkImage(novelViewModel.novels[idNovel].linkImage),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          novelViewModel.novels[idNovel].linkImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            novelViewModel.novels[idNovel].judul,
                            style: GoogleFonts.roboto(fontSize: 25),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            novelViewModel.novels[idNovel].author,
                            style: GoogleFonts.roboto(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              novelViewModel.novels[idNovel].status ==
                                      'Berlanjut'
                                  ? const Icon(Icons.schedule_rounded, size: 17)
                                  : const Icon(Icons.check, size: 17),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                novelViewModel.novels[idNovel].status,
                                style: GoogleFonts.roboto(fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                color: colorPrimary2,
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Text(
                  novelViewModel.novels[idNovel].sinopsis,
                  style: GoogleFonts.roboto(fontSize: 15),
                ),
                // ),
              ),
              ListTile(
                title: const Text(
                  'Chapter',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.sort_by_alpha),
                  onPressed: () {
                    novelViewModel.sortChapter(idNovel);
                  },
                ),
              ),
              Flexible(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: chapter.length,
                    itemBuilder: (ctx, i) {
                      return InkWell(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Delete Chapter'),
                                content: const Text('Are you sure?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      publishViewModel.deleteChapter(
                                          keyNovel, chapter[i].id);
                                      Navigator.pop(context);
                                      await Future.delayed(
                                        const Duration(
                                          milliseconds: 500,
                                        ),
                                      );
                                      novelViewModel.init();
                                    },
                                    child: const Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ChapterView.routeName,
                            arguments: {
                              'idNovel': idNovel,
                              'idChapter': chapter[i].id,
                            },
                          );
                        },
                        child: ListTile(
                          title: Text(chapter[i].judulChapter),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: colorPrimary4,
          onPressed: () {
            Navigator.pushNamed(context, PostChapterView.routeName,
                arguments: novelViewModel.novels[idNovel].id);
          },
          child: const Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
    );
  }
}
