import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:improove/data.dart';
import 'package:improove/widgets/preview_card.dart';

class TrainerScreen extends StatelessWidget {
  final String id;
  const TrainerScreen({
    Key? key,
    this.id = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            expandedHeight: size.height * 0.35,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              iconSize: 32,
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            flexibleSpace: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      currentUser.thumbnailUrl,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 35,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(0, 2),
                        ),
                      ],
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    currentUser.username,
                    style: textTheme.headline4
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ExpandableText(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit ess Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit ess",
                    expandText: "expand",
                    collapseText: "collapse",
                    linkColor: colorScheme.primary,
                    maxLines: 6,
                    style: textTheme.subtitle1
                        ?.copyWith(color: colorScheme.primary.withOpacity(.59)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    top: 35.0,
                    bottom: 25.0,
                  ),
                  child: Text(
                    "My Courses",
                    style: textTheme.headline6
                        ?.copyWith(color: colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: size.width * (92 / 254) * (135 / 92),
              width: size.width,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 19.0, right: 19.0),
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 6, right: 6),
                    child: PreviewCard(
                      preview: currentUser.thumbnailUrl,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
