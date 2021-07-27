import 'package:flutter/material.dart';
import 'package:improove/data.dart';
import 'package:improove/widgets/preview_card.dart';
import 'package:improove/widgets/cta_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double heightScreen = MediaQuery.of(context).size.height;
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            ///Properties of app bar
            backgroundColor: Colors.white,
            pinned: true,
            expandedHeight: heightScreen / 8,

            ///Properties of the App Bar when it is expanded
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Improove",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return SizedBox(
                  child: Center(
                    child: PreviewCard(
                      category: "Category",
                      preview: fakeTraining.preview,
                      avatar: currentUser.thumbnailUrl,
                    ),
                  ),
                );
              },
              childCount: 10,
            ),
          ),
          SliverToBoxAdapter(
              child: SizedBox(
                  height: size.width * (198 / 254) * (135 / 198),
                  width: size.width * (198 / 254),
                  child: CtaCard()))
        ],
      ),
    );
  }
}
