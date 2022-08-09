import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';


class StoryVieww extends StatefulWidget {
  const StoryVieww({Key? key}) : super(key: key);

  @override
  State<StoryVieww> createState() => _StoryViewwState();
}

class _StoryViewwState extends State<StoryVieww> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(
          storyItems: [
            StoryItem.pageImage(
              url: "https://i.pinimg.com/originals/f6/eb/53/f6eb535411056b553dfdec1665387c0c.jpg",
              caption: "Simply beautiful😘😘😘",
              controller: storyController
            ),
            StoryItem.pageImage(
                url: "https://i.pinimg.com/originals/f6/eb/53/f6eb535411056b553dfdec1665387c0c.jpg",
                caption: "Simply beautiful😘😘😘",
                controller: storyController
            ),
            StoryItem.pageImage(
                url: "https://i.pinimg.com/originals/f6/eb/53/f6eb535411056b553dfdec1665387c0c.jpg",
                caption: "Simply beautiful😘😘😘",
                controller: storyController
            ),
            StoryItem.pageImage(
                url: "https://i.pinimg.com/originals/f6/eb/53/f6eb535411056b553dfdec1665387c0c.jpg",
                caption: "Simply beautiful😘😘😘",
                controller: storyController
            ),

            //The StoryItem.pageGif accepts a GIf, you can add any Gif you want
            //It accepts a caption. The caption describes the Gif
            StoryItem.pageImage(
             url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
              caption: "Thanks for watching",
              controller: storyController,
            ),

            //The StoryItem.pageVideo accepts a Video.
            //It accepts a caption. The caption describes the video
            StoryItem.pageVideo(
                "https://firebasestorage.googleapis.com/v0/b/tactile-timer-267314.appspot.com/o/Hang%20-%2030902.mp4?alt=media&token=74eec54b-7c4a-43dc-bd7a-522a494b69c0",
                caption: "title of the video",
                controller: storyController,
                shown: true,
                duration: Duration(seconds: 4)
            ),
          ],
        controller: storyController,
      ),
    );
  }
}
