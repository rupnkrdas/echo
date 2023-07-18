import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:echo/constants/colors.dart';
import 'package:echo/services/openai_service.dart';
import 'package:echo/views/widgets/feature_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:neopop/neopop.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final speechToText = SpeechToText();
  String _lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  final FlutterTts flutterTts = FlutterTts();
  String? generatedContent;
  String? generatedImageURL;
  int start = 200;
  int delay = 200;

  bool isListening = false;
  bool isGeneratingImage = false;

  @override
  void initState() {
    initSpeechToText();
    initTextToSpeech();

    super.initState();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    // Set the audio output to the main speaker on both iOS and Android
    await flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.ambient,
      [IosTextToSpeechAudioCategoryOptions.allowBluetooth, IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP, IosTextToSpeechAudioCategoryOptions.mixWithOthers],
      IosTextToSpeechAudioMode.voicePrompt,
    );
    await flutterTts.setVolume(1.0);
    await flutterTts.setVoice({"name": "Allison (Enhanced)", "locale": "en-US"});
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    speechToText.initialize();
    setState(() {});
  }

  /// Start a speech recognition session
  Future<void> _startListening() async {
    setState(() {
      isListening = true;
    });
    await speechToText.listen(onResult: _onSpeechResult);
  }

  /// Stop the active speech recognition session
  Future<void> _stopListening() async {
    await speechToText.stop();
    setState(() {
      isListening = false;
    });
  }

  /// Callback when the platform returns recognized words
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    speechToText.stop();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("isListening: $isListening");
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.h).copyWith(bottom: 35.h),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),

            // AI-image
            ZoomIn(
              duration: const Duration(milliseconds: 1000),
              child: SizedBox(
                height: 150.h,
                child: Image.asset(
                  'assets/images/bot.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // chat-bubble
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      FadeIn(
                        delay: Duration(milliseconds: start + delay * 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.deepPurple.shade400.withOpacity(0.1),
                            ),
                            borderRadius: BorderRadius.circular(20).copyWith(
                              topLeft: const Radius.circular(0),
                            ),
                            gradient: RadialGradient(
                              center: Alignment.bottomRight,
                              radius: 5.r,
                              colors: [
                                Colors.deepPurple.shade200.withOpacity(0.1),
                                Colors.deepPurple.shade200.withOpacity(0.3),
                              ],

                              // begin: Alignment.topLeft,
                              // end: Alignment.bottomRight,
                            ),
                          ),
                          child: Text(
                            (generatedContent == null) ? 'Hi, I\'m Echo.\nHow can I help you?' : generatedContent!,
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: (generatedContent == null) ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20.h,
                      ),
                      // generated-image
                      if (generatedImageURL != null) ...[
                        Center(
                          child: FutureBuilder(
                            future: precacheImage(NetworkImage(generatedImageURL!), context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return FadeIn(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Image.network(
                                        generatedImageURL!,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Lottie.asset(
                                  'assets/lottiefiles/image_loading_animation_3.json',
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.fill,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                  IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.backgroundColor.withOpacity(0),
                            AppTheme.backgroundColor.withOpacity(0),
                            AppTheme.backgroundColor.withOpacity(0),
                            AppTheme.backgroundColor.withOpacity(0),
                            AppTheme.backgroundColor.withOpacity(0),
                            AppTheme.backgroundColor.withOpacity(0),
                            AppTheme.backgroundColor.withOpacity(0),
                            AppTheme.backgroundColor.withOpacity(0),
                            AppTheme.backgroundColor.withOpacity(0),
                            AppTheme.backgroundColor.withOpacity(0),
                            AppTheme.backgroundColor.withOpacity(0),
                            AppTheme.backgroundColor.withOpacity(0),
                            AppTheme.backgroundColor.withOpacity(0),
                            AppTheme.backgroundColor.withOpacity(0),
                            AppTheme.backgroundColor.withOpacity(0),
                            AppTheme.backgroundColor.withOpacity(0),
                            AppTheme.backgroundColor.withOpacity(0),
                            AppTheme.backgroundColor.withOpacity(0),
                            AppTheme.backgroundColor.withOpacity(0),
                            AppTheme.backgroundColor.withOpacity(0.5),
                            AppTheme.backgroundColor.withOpacity(1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // features header
            Visibility(
              visible: generatedContent == null && generatedImageURL == null,
              child: SlideInLeft(
                delay: Duration(milliseconds: start),
                child: Padding(
                  padding: EdgeInsets.only(left: 5.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Here are a few features',
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // features list
            Visibility(
              visible: generatedContent == null && generatedImageURL == null,
              child: Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 15.h),
                      children: [
                        SlideInLeft(
                          delay: Duration(milliseconds: start),
                          child: FeatureBox(
                            color: AppTheme.firstSuggestionBoxColor,
                            headerText: 'ChatGPT',
                            desctriptionText: 'A smarter way to stay organised and informed with ChatGPT',
                          ),
                        ),
                        SizedBox(height: 10.h),
                        SlideInLeft(
                          delay: Duration(milliseconds: start + delay),
                          child: FeatureBox(
                            color: AppTheme.secondSuggestionBoxColor,
                            headerText: 'Dall-E',
                            desctriptionText: 'Get inspired and stay creative with your personal assistant powered by Dall-E',
                          ),
                        ),
                        SizedBox(height: 10.h),
                        SlideInLeft(
                          delay: Duration(milliseconds: start + delay * 2),
                          child: FeatureBox(
                            color: AppTheme.firstSuggestionBoxColor,
                            headerText: 'Smart Voice Assistant',
                            desctriptionText: 'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT',
                          ),
                        ),
                      ],
                    ),
                    IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.backgroundColor.withOpacity(0.99),
                              AppTheme.backgroundColor.withOpacity(0),
                              AppTheme.backgroundColor.withOpacity(0),
                              AppTheme.backgroundColor.withOpacity(0),
                              AppTheme.backgroundColor.withOpacity(0),
                              AppTheme.backgroundColor.withOpacity(0),
                              AppTheme.backgroundColor.withOpacity(0),
                              AppTheme.backgroundColor.withOpacity(0),
                              AppTheme.backgroundColor.withOpacity(0),
                              AppTheme.backgroundColor.withOpacity(0),
                              AppTheme.backgroundColor.withOpacity(0),
                              AppTheme.backgroundColor.withOpacity(0),
                              AppTheme.backgroundColor.withOpacity(0),
                              AppTheme.backgroundColor.withOpacity(0),
                              AppTheme.backgroundColor.withOpacity(0),
                              AppTheme.backgroundColor.withOpacity(0),
                              AppTheme.backgroundColor.withOpacity(0),
                              AppTheme.backgroundColor.withOpacity(0.5),
                              AppTheme.backgroundColor.withOpacity(1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: (generatedContent == null && generatedImageURL == null) ? 20.h : 0,
            ),

            Visibility(
              visible: (_lastWords.isNotEmpty),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.h),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.deepPurple.shade400.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.circular(10.r).copyWith(
                      bottomRight: Radius.circular(2.r),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.shade200.withOpacity(0.1),
                        Colors.deepPurple.shade200.withOpacity(0.2),
                        Colors.deepPurple.shade200.withOpacity(0.2),
                        Colors.deepPurple.shade200.withOpacity(0.2),
                        Colors.deepPurple.shade200.withOpacity(0.2),
                        Colors.deepPurple.shade200.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Text(
                    _lastWords,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: (generatedContent == null) ? FontWeight.w600 : FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 8.h,
            ),
            // button
            ZoomIn(
              delay: Duration(milliseconds: start + delay * 3),
              child: NeoPopTiltedButton(
                isFloating: true,
                onTapUp: () {},
                onTapDown: () async {
                  setState(() {
                    isListening = false;
                  });
                  if (await speechToText.hasPermission && speechToText.isNotListening) {
                    setState(() {
                      isListening = true;
                      generatedContent = null;
                    });
                    await _startListening();
                  } else if (speechToText.isListening) {
                    setState(() {
                      isListening = false;
                      isGeneratingImage = true;
                    });
                    final speech = await openAIService.determineResponseType(_lastWords);
                    if (speech.contains('https')) {
                      // if the response is an image
                      setState(() {
                        generatedImageURL = speech;
                        generatedContent = null;
                        isGeneratingImage = false;
                      });
                    } else {
                      // if the response is text
                      setState(() {
                        generatedImageURL = null;
                        generatedContent = speech;
                        isGeneratingImage = false;
                      });
                      await systemSpeak(speech);
                    }
                    await _stopListening();
                  } else {
                    initSpeechToText();
                  }
                },
                decoration: NeoPopTiltedButtonDecoration(
                  color: Colors.deepPurple.shade200,
                  plunkColor: Colors.deepPurple.shade500,
                  shadowColor: const Color.fromRGBO(36, 36, 36, 1),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                  ),
                  child: SizedBox(
                    height: 20.h,
                    child: Row(
                      children: [
                        const Spacer(),
                        Row(
                          children: [
                            if (!isListening && !isGeneratingImage) ...[
                              Text(
                                'Speak',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.backgroundColor,
                                ),
                              ),
                              const Icon(
                                Icons.mic_rounded,
                                color: AppTheme.backgroundColor,
                              ),
                            ] else if (isListening) ...[
                              Text(
                                'Stop',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.backgroundColor,
                                ),
                              ),
                              const Icon(
                                Icons.stop_rounded,
                                color: AppTheme.backgroundColor,
                              ),
                            ] else if (isGeneratingImage) ...[
                              Lottie.asset(
                                'assets/lottiefiles/button_loading_animation.json',
                                fit: BoxFit.fitHeight,
                                // width: 30.w,
                                // height: 30.w,
                              ),
                            ],
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
