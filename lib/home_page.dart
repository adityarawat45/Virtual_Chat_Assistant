import 'package:allen/features_box.dart';
import 'package:allen/openai_service.dart';
import 'package:allen/pallete.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  String lastWords = '';
  final OpenAIService service = OpenAIService();
  @override
  void initState() {
    super.initState();
    initSpeechToText();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Allen".text.make(),
        centerTitle: true,
        leading: const Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //The chat assistant picture stuff
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle),
                  ),
                ),
                Container(
                  height: 123,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/images/virtualAssistant.png"))),
                )
              ],
            ),
            //Chat bubbles
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                top: 30,
              ),
              decoration: BoxDecoration(
                  border: Border.all(color: Pallete.borderColor),
                  borderRadius:
                      BorderRadius.circular(20).copyWith(topLeft: Radius.zero)),
              child: "Good Morning,what task can i do for you?"
                  .text
                  .fontFamily('Cera Pro')
                  .color(Pallete.mainFontColor)
                  .size(25)
                  .make()
                  .pSymmetric(v: 10),
            ),
            //suggestions list
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 10, left: 22),
              child: "Here are a few features"
                  .text
                  .fontFamily('Cera Pro')
                  .color(Pallete.mainFontColor)
                  .size(20)
                  .align(TextAlign.left)
                  .bold
                  .make(),
            ).p(10),
            //features list
            const Column(
              children: [
                Featurebox(
                  color: Pallete.firstSuggestionBoxColor,
                  headerText: 'ChatGpt',
                  description:
                      "A smarter way to stay organized and informed with ChatGPT",
                ),
                //  HeightBox(3),
                Featurebox(
                    color: Pallete.secondSuggestionBoxColor,
                    headerText: 'Dall-E',
                    description:
                        'Get inspired and stay creative with your personal asistant powered by Dall-E'),
                Featurebox(
                    color: Pallete.thirdSuggestionBoxColor,
                    headerText: 'Smart Voice Asistant',
                    description:
                        'Get the best of both worlds with a smart AI voice assitant')
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
            await service.isArtPrompt(lastWords);
            await stopListening();
          } else {
            initSpeechToText();
          }
        },
        child: const Icon(Icons.mic),
      ),
    );
  }
}
