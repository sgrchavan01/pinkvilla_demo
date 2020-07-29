import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pinkvilla_demo/model/videomodel.dart';
import 'package:pinkvilla_demo/theme/colors.dart';
import 'package:pinkvilla_demo/widgets/column_social_icon.dart';
import 'package:pinkvilla_demo/widgets/header_home_page.dart';
import 'package:pinkvilla_demo/widgets/left_panel.dart';
import 'package:pinkvilla_demo/widgets/tik_tok_icons.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<VideoModel> _videoModel = [];
  bool _isLoading = false;
   Future<Null> getVideoList() async {
    _videoModel=[];
     final response = await get("https://www.pinkvilla.com/feed/video-test/video-feed.json");
      final responseJson = json.decode(response.body);
  
      setState(() {
        for (Map user in responseJson) {
          _videoModel.add(VideoModel.fromJson(user));
        }
        _tabController = TabController(length: _videoModel.length, vsync: this);
         _isLoading = false;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVideoList();
     _isLoading = true;
       
      }
    
      @override
      void dispose() {
        // TODO: implement dispose
        super.dispose();
        _tabController.dispose();
      }
    
      @override
      Widget build(BuildContext context) {
        return getBody();
      }
    
      Widget getBody() {
        var size = MediaQuery.of(context).size;
        return RotatedBox(
          quarterTurns: 1,
          child:   _isLoading
          ? Center(child: CircularProgressIndicator())
          :TabBarView(
            controller: _tabController,
            children: List.generate(_videoModel.length, (index) {
              return VideoPlayerItem(
                videoUrl: _videoModel[index].url,
                size: size,
                name: _videoModel[index].name,
                caption: _videoModel[index].title,
                profileImg: _videoModel[index].headshot,
                likes: _videoModel[index].likecount.toString(),
                comments: _videoModel[index].commentcount.toString(),
                shares: _videoModel[index].sharecount.toString(),
              );
            }),
          ),
        );
      }
    
      void getDataList() {}
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String name;
  final String caption;
  final String profileImg;
  final String likes;
  final String comments;
  final String shares;
  VideoPlayerItem(
      {Key key,
      @required this.size,
      this.name,
      this.caption,
      this.profileImg,
      this.likes,
      this.comments,
      this.shares,
      this.videoUrl})
      : super(key: key);

  final Size size;

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController _videoController;
  bool isShowPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
       _videoController.play();
        setState(() {
          
          isShowPlaying = false;
        });
      });

      
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoController.dispose();

    
  }
  Widget isPlaying(){
    return _videoController.value.isPlaying && !isShowPlaying  ? Container() : Icon(Icons.play_arrow,size: 80,color: white.withOpacity(0.5),);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _videoController.value.isPlaying
              ? _videoController.pause()
              : _videoController.play();
        });
      },
      child: RotatedBox(
        quarterTurns: -1,
        child: Container(
            height: widget.size.height,
            width: widget.size.width,
            child: Stack(
              children: <Widget>[
                Container(
                  height: widget.size.height,
                  width: widget.size.width,
                  decoration: BoxDecoration(color: black),
                  child: Stack(
                    children: <Widget>[
                      VideoPlayer(_videoController),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                          ),
                          child: isPlaying(),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: widget.size.height,
                  width: widget.size.width,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 15, top: 20, bottom: 10),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          HeaderHomePage(),
                          Expanded(
                              child: Row(
                            children: <Widget>[
                              LeftPanel(
                                size: widget.size,
                                name: "${widget.name}",
                                caption: "${widget.caption}",
                               // songName: "${widget.songName}",
                              ),
                              RightPanel(
                                size: widget.size,
                                likes: "${widget.likes}",
                                comments: "${widget.comments}",
                                shares: "${widget.shares}",
                                profileImg: "${widget.profileImg}",
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class RightPanel extends StatelessWidget {
  final String likes;
  final String comments;
  final String shares;
  final String profileImg;
  final String albumImg;
  const RightPanel({
    Key key,
    @required this.size,
    this.likes,
    this.comments,
    this.shares,
    this.profileImg,
    this.albumImg,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: size.height,
        child: Column(
          children: <Widget>[
            Container(
              height: size.height * 0.3,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                getProfile(profileImg),
                getIcons(TikTokIcons.heart, likes, 35.0),
                getIcons(TikTokIcons.chat_bubble, comments, 35.0),
                getIcons(TikTokIcons.reply, shares, 25.0),
              
              ],
            ))
          ],
        ),
      ),
    );
  }
}
