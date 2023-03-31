import 'dart:convert';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import "colors.dart" as color;

class ChieweInfo extends StatefulWidget {
  const ChieweInfo({Key? key}) : super(key: key);

  @override
  _ChieweInfoState createState() => _ChieweInfoState();
}

class _ChieweInfoState extends State<ChieweInfo> {
  List videoInfo = [];
  VideoPlayerController? _videoPlayerController;
  ChewieController? chewieController;
  bool isVideoShowen = false;
  bool _dispose = false;
  int _playingIndex = -1;
  bool _isMute = false;
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
    chewieController?.dispose();
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
              height: 320,
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
          aspectRatio: 16 / 9,
          child: Chewie(
            controller: chewieController!,
          )

          //  VideoPlayer(controller),
          );
    } else {
      return const AspectRatio(
        aspectRatio: 16 / 9,
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
      oldController.pause();
    }
    setState(() {});
    // ignore: avoid_single_cascade_in_expression_statements
    videoPlayerController
      ..initialize().then((_) {
        oldController?.dispose();
        _playingIndex = index;
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          autoPlay: true,
          looping: true,
        );
        videoPlayerController.play();
        setState(() {});
      });
  }

  var thumbnailFile;
  buildListView(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: videoInfo.length,
        itemBuilder: (context, index) {
          //  _createVideoThumbnail(videoInfo[index]['videoUrl']);
          return GestureDetector(
              onTap: () {
                _initializeVideo(index);
                setState(() {
                  if (isVideoShowen == false) {
                    isVideoShowen = true;
                  }
                });
              },
              child: Text(videoInfo[index]['title']));

          //   Container(
          //       child: (thumbnailFile == null)
          //           ? Text('Loading...')
          //           : Image.file(
          //               File(thumbnailFile),
          //               width: 30,
          //               fit: BoxFit.cover,
          //             )
          //       // child: Text(videoInfo[index]['title']),
          //       ),
          // );
        },
      ),
    );
  }

  _createVideoThumbnail(String videoUrl) async {
    thumbnailFile = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight:
          64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );
    setState(() {});
  }
}
