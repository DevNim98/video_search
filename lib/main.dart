import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_search/video_provider.dart';
import 'video_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Video Search';
    return Provider(
      create: (_) => VideoProvider(),
      child: MaterialApp(
        title: appTitle,
        home: Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
          ),
          body: SafeArea(child: HomePage()),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String label = 'default';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            onSubmitted: (value) {
              setState(() {
                label = value;
              });
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
              future: Future.delayed(const Duration(seconds: 2)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      var videoProvider = Provider.of<VideoProvider>(context);
                      return ListTile(
                        title: Text('Titulo del video'),
                        onTap: () {
                          videoProvider.selectedvideoTittle =
                              'selected video tittle';
                          videoProvider.selectedvideoURL = 'selected video URL';
                          videoProvider.selectedlabelTimestamps = <String>[
                            'timestamp1',
                            'timestamp2',
                          ];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              //TODO: Pasar url del video por el constructor tambien
                              builder: (context) => VideoPage(
                                  'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4'),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        )
      ],
    );
  }
}
