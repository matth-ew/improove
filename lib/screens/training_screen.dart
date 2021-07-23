import 'package:flutter/material.dart';
import 'package:improove/data.dart';
import 'package:improove/widgets/preview_card.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({
    Key? key,
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
            expandedHeight: size.height * 0.45,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              iconSize: 32,
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
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
                  bottom: -2,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 35,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 35,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    child: GestureDetector(
                      onTap: () => {},
                      child: FadeInImage(
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder:
                            const AssetImage("assets/trainer_avatar.png"),
                        image: NetworkImage(currentUser.thumbnailUrl),
                      ),
                    ),
                  ),
                  // Container(
                  //   height: 35,
                  //   decoration: const BoxDecoration(
                  //     borderRadius: BorderRadius.only(
                  //       topLeft: Radius.circular(35),
                  //       topRight: Radius.circular(35),
                  //     ),
                  //     color: Colors.white,
                  //   ),
                  // ),
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
                    "Nome Challenge",
                    style: textTheme.headline4
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                    style: textTheme.subtitle1
                        ?.copyWith(color: colorScheme.primary.withOpacity(.59)),
                  ),
                ),
              ],
            ),
          ),
          const SliverPadding(padding: EdgeInsets.all(5)),
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
                      avatar: currentUser.profileImageUrl,
                      preview: currentUser.thumbnailUrl,
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.all(5)),
        ],
      ),
    );
  }
}
