import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import "colors.dart" as color;

class VideoInfo extends StatefulWidget {
  const VideoInfo({Key? key}) : super(key: key);

  @override
  _VideoInfoState createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {
  List videoInfo = [];
  VideoPlayerController? _videoPlayerController;
  bool isVideoShowen = false;
  bool isPlaying = false;
  bool _dispose = false;
  int _playingIndex = -1;
  _initData() async {
    await DefaultAssetBundle.of(context)
        .loadString("assets/json/videoinfo.json")
        .then((value) {
      setState(() {
        videoInfo = json.decode(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initData();
    //_onTapVideo(-1);
  }

  @override
  void dispose() {
    _dispose = true;
    _videoPlayerController?.pause();
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          color.AppColor.gradientFirst.withOpacity(0.9),
          color.AppColor.gradientSecond
        ],
        begin: const FractionalOffset(0.0, 0.4),
        end: Alignment.topRight,
      )),
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: (isVideoShowen == false)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Icon(Icons.arrow_back_ios,
                                  size: 20,
                                  color: color.AppColor.secondPageIconColor),
                            ),
                            Expanded(child: Container()),
                            Icon(Icons.info_outline,
                                size: 20,
                                color: color.AppColor.secondPageIconColor),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Legs Toning",
                          style: TextStyle(
                              fontSize: 25,
                              color: color.AppColor.secondPageTitleColor),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "and Glutes Workout",
                          style: TextStyle(
                              fontSize: 25,
                              color: color.AppColor.secondPageTitleColor),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 90,
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [
                                      color.AppColor
                                          .secondPageContainerGradient1stColor,
                                      color.AppColor
                                          .secondPageContainerGradient2ndColor
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.timer,
                                    size: 20,
                                    color: color.AppColor.secondPageIconColor,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "68 min",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            color.AppColor.secondPageIconColor),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: 220,
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [
                                      color.AppColor
                                          .secondPageContainerGradient1stColor,
                                      color.AppColor
                                          .secondPageContainerGradient2ndColor
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.handyman_outlined,
                                    size: 20,
                                    color: color.AppColor.secondPageIconColor,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Resistent band, kettebell",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            color.AppColor.secondPageIconColor),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [_playVideo(context), _controlVideo(context)],
                    )),
          Expanded(
              child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(70))),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "Circuit 1: Legs Toning",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color.AppColor.circuitsColor),
                    ),
                    Expanded(child: Container()),
                    Row(
                      children: [
                        Icon(Icons.loop,
                            size: 30, color: color.AppColor.loopColor),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "3 sets",
                          style: TextStyle(
                            fontSize: 15,
                            color: color.AppColor.setsColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                buildListView(context)
              ],
            ),
          ))
        ],
      ),
    ));
  }

  _controlVideo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () async {
            final index = _playingIndex - 1;
            if (index > 0 && videoInfo.isNotEmpty) {
              _initializeVideo(index);
            } else {
              debugPrint('NI VIDEOS NOW ');
            }
          },
          icon: const Icon(Icons.fast_rewind),
        ),
        //isPlaying
        IconButton(
          onPressed: () async {
            if (isPlaying) {
              setState(() {
                isPlaying = true;
              });
              _videoPlayerController!.pause();
            } else {
              setState(() {
                isPlaying = false;
              });
              _videoPlayerController!.play();
            }
          },
          icon: Icon(isPlaying ? Icons.pause : Icons.play_circle),
        ),
        IconButton(
          onPressed: () async {
            final index = _playingIndex + 1;
            if (index < videoInfo.length) {
              _initializeVideo(index);
            } else {
              debugPrint('YOU WATCHED ALL VIDEOS ');
            }
          },
          icon: const Icon(Icons.fast_forward),
        ),
      ],
    );
  }

  _playVideo(BuildContext context) {
    final controller = _videoPlayerController;
    if (controller != null && controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: 18 / 9,
        child: VideoPlayer(controller),
      );
    } else {
      return const AspectRatio(
        aspectRatio: 18 / 9,
        child: Center(child: Text('Loading....')),
      );
    }
  }

  _initializeVideo(int index) {
    final videoPlayerController =
        VideoPlayerController.network(videoInfo[index]['videoUrl']);
    final oldController = _videoPlayerController;
    _videoPlayerController = videoPlayerController;
    if (oldController != null) {
      oldController.removeListener(_controllerUpdate);
      oldController.pause();
    }
    setState(() {});
    // ignore: avoid_single_cascade_in_expression_statements
    videoPlayerController
      ..initialize().then((_) {
        oldController?.dispose();
        _playingIndex = index;
        videoPlayerController.addListener(_controllerUpdate);
        videoPlayerController.play();
        setState(() {});
      });
  }

  void _controllerUpdate() async {
    if (_dispose) {
      return;
    }
    final controller = _videoPlayerController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    } else {
      final bool playing = controller.value.isPlaying;
      isPlaying = playing;
    }
  }

  buildListView(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        itemCount: videoInfo.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _initializeVideo(index);
              setState(() {
                if (isVideoShowen == false) {
                  isVideoShowen = true;
                }
              });
            },
            child: Container(
              height: 50,
              color: Colors.grey,
              width: double.infinity,
              child: Text(videoInfo[index]['title']),
            ),
          );
        },
      ),
    );
  }
}
