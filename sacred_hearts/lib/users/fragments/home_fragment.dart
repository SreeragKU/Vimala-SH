import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: PageView(
                children: const [
                  SliderWidget(
                    imageUrl: 'images/slider1.jpg',
                    caption1: 'TRANSFORMING LIVES',
                    caption2: 'RESTORING HOPE',
                    statement: 'Transforming lives and societies through education, research and innovation.',
                  ),
                  SliderWidget(
                    imageUrl: 'images/slider2.jpg',
                    caption1: 'PUT YOUR FAITH',
                    caption2: 'INTO ACTION',
                    statement: 'Put your faith into action today and let your actions be fueled by your faith.',
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Important Links',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      _buildLinkItem(
                        imageUrl: 'images/pic.png',
                        link: 'http://www.pocbible.com/',
                        title: 'P.O.C Bible Online',
                        context: context,
                      ),
                      _buildLinkItem(
                        imageUrl: 'images/vatican.png',
                        link: 'http://w2.vatican.va/content/vatican/en.html',
                        title: 'Vatican.va',
                        context: context,
                      ),
                      _buildLinkItem(
                        imageUrl: 'images/smchurch.png',
                        link: 'http://www.syromalabarchurch.in',
                        title: 'Syro-Malabar Church',
                        context: context,
                      ),
                      _buildLinkItem(
                        imageUrl: 'images/founder.png',
                        link: 'http://www.kadalikkattilachan.org/',
                        title: 'Kadalikkattilachan',
                        context: context,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkItem({required String imageUrl, required String link, required String title, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () async {
          try {
            await launchUrl(
                Uri.parse(link),
                customTabsOptions: CustomTabsOptions(
                  colorSchemes: CustomTabsColorSchemes.defaults(
                    toolbarColor: Theme.of(context).primaryColor,
                  ),
                ));
          } catch (e) {
            throw 'Could not launch $link';
          }
        },
        child: Row(
          children: [
            Image.asset(
              imageUrl,
              height: 110,
              width: 110,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class SliderWidget extends StatelessWidget {
  final String imageUrl;
  final String caption1;
  final String caption2;
  final String statement;

  const SliderWidget({
    required this.imageUrl,
    required this.caption1,
    required this.caption2,
    required this.statement,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  caption1,
                  style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold, shadows: [
                    Shadow(
                      blurRadius: 20.0,
                      color: Colors.black,
                      offset: Offset(1.0, 1.0),
                    ),
                  ]),
                ),
                const SizedBox(height: 8),
                Text(
                  caption2,
                  style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold, shadows: [
                    Shadow(
                      blurRadius: 20.0,
                      color: Colors.black,
                      offset: Offset(1.0, 1.0),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: Text(
                statement,
                style: const TextStyle(fontSize: 24, color: Colors.white, shadows: [
                  Shadow(
                    blurRadius: 20.0,
                    color: Colors.black,
                    offset: Offset(1.0, 1.0),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
