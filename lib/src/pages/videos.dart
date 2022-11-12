import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:youtube_api/youtube_api.dart';

class Videos extends StatefulWidget {
  const Videos({super.key});

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  static String api_key = "AIzaSyAtUPqzUjI2ojILwMHJd23xxivExtI9oww";

  YoutubeAPI youtube = YoutubeAPI(api_key, type: "Video");
  List<YouTubeVideo> videoResult = [];

  Future<List<YouTubeVideo>> callAPI(String text) async {
    String query = text;
    videoResult = await youtube.search(
      query,
      type: "Video",
      order: 'relevance',
      videoDuration: 'any',
    );
    return videoResult;
  }

  Future<void> _abreVideo(BuildContext context, String url) async {
    if (!await launchUrlString(url)) {
      SnackBar snack = const SnackBar(
        content: Text("No se pudo abrir el video :c"),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Videos")),
      body: _body(),
    );
  }

  Widget _body() {
    return FutureBuilder<List<YouTubeVideo>>(
        future: callAPI("Nach"),
        builder:
            (BuildContext context, AsyncSnapshot<List<YouTubeVideo>> snapshot) {
          if (snapshot.hasData) {
            // List<YouTubeVideo> datos = respuesta.data;
            return _scroll(videoResult);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _scroll(List<YouTubeVideo> video) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Divider(
              height: 40,
              color: Color.fromARGB(255, 38, 133, 69),
            ),
            const Center(
              child: Text(
                "Videos de Youtube",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // videoResult.map<Widget>(_listaVideos).toList()
            _listaVideos(video.toList()),
          ],
        ),
      ),
    );
  }

  Widget _listaVideos(List<YouTubeVideo> videos) {
    return ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) => ListTile(
              leading: IconButton(
                icon: ClipRRect(
                  child: Image.network(
                    'https://img.youtube.com/vi/${Uri.parse(videos[index].url).queryParameters['v']}/0.jpg',
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) {
                        return child;
                      }
                      return AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeOut,
                        child: child,
                      );
                    },
                  ),
                ),
                onPressed: () {
                  String url = videos[index].url;
                  _abreVideo(context, url);
                  debugPrint(url);
                },
                iconSize: 100,
              ),
              title: Text(videos[index].title),
            ),
        separatorBuilder: (context, index) => const Divider(
              color: Colors.blue,
            ),
        itemCount: videos.length);
  }
}
