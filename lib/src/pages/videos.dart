import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:youtube_api/youtube_api.dart';

class Videos extends StatefulWidget {
  const Videos({super.key});

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  static String api_key = "AIzaSyBj7MhCqMS-6JJ4W6BdArLmw2SSwXXKJxY";
  String busqueda = "Sistema de riego";
  YoutubeAPI youtube = YoutubeAPI(api_key, type: "Video");
  List<YouTubeVideo> videoResult = [];

  Future<List<YouTubeVideo>> callAPI() async {
    String query = busqueda;
    if (query == "") {
      query = "Sistema de riego";
    }
    videoResult = await youtube.search(
      query,
      type: "Video",
      order: 'relevance',
      videoDuration: 'any',
    );
    return videoResult;
  }

  Future<void> _abreVideo(BuildContext context, String url) async {
    SnackBar snack_1 = const SnackBar(
      content: Text("Abriendo..."),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack_1);

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
        future: callAPI(),
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
              height: 100,
              color: Color.fromARGB(255, 38, 133, 69),
            ),
            const Center(
              child: Text(
                "Videos de EcoTic",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 26, 77, 27)),
              ),
            ),
            const Divider(
              height: 50,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            _buscador(),
            const Divider(
              height: 100,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            _listadeVideos(video.toList()),
          ],
        ),
      ),
    );
  }

  Widget _listadeVideos(List<YouTubeVideo> videos) {
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemBuilder: (context, index) => ListTile(
        title: Image.network(
          'https://img.youtube.com/vi/${Uri.parse(videos[index].url).queryParameters['v']}/0.jpg',
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
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
        subtitle: Text(
          videos[index].title,
          style: const TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          String url = videos[index].url;
          _abreVideo(context, url);
          debugPrint(url);
        },
      ),
      itemCount: videos.length,
      separatorBuilder: (context, index) => const Divider(
        color: Colors.green,
        height: 50,
      ),
    );
  }

  Widget _buscador() {
    double width = MediaQuery.of(context).size.width * 0.88;
    return Row(
      children: [
        SizedBox(
          width: width,
          child: TextField(
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              labelText: "Buscar un video",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              busqueda = value;
            },
          ),
        ),
      ],
    );
  }
}
