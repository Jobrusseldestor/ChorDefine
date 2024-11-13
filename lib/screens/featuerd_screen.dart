import 'dart:ui';
import 'package:chordefine/constants/size.dart';
import 'package:chordefine/models/category.dart';
import 'package:chordefine/screens/learnscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FeaturedScreen extends StatefulWidget {
  const FeaturedScreen({Key? key}) : super(key: key);

  @override
  _FeaturedScreenState createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> {
  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
         backgroundColor: Color.fromARGB(255, 241, 240, 240),
        body: Column(
          children: [
            GlassmorphicAppBar(),
            SizedBox(height: 16), // Spacing below the AppBar
            Expanded(child: Body()),
          ],
        ),
      ),
    );
  }
}

class GlassmorphicAppBar extends StatelessWidget {
  const GlassmorphicAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 1, left: 0, right: 0),
      height: 150,
      width: double.infinity,
      child: Stack(
        children: [
          // Blurred background
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color.fromARGB(245, 245, 110, 15).withOpacity(1),
                      const Color.fromARGB(245, 245, 110, 15).withOpacity(1),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
            ),
          ),
          // Centered Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Welcome to",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3.0,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
                Text(
                  "CHORDEFINE",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3.0,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text(
              //   "Explore Categories",
              //   style: Theme.of(context).textTheme.bodyLarge,
              // ),
              // TextButton(
              //   onPressed: () {},
              //   child: Text(
              //     "See All",
              //     style: Theme.of(context)
              //         .textTheme
              //         .bodyMedium
              //         ?.copyWith(color: kPrimaryColor),
              //   ),
              // ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 25,
              mainAxisSpacing: 25,
            ),
            itemBuilder: (context, index) {
              final colors = [Color.fromARGB(255, 255, 251, 247)];
              final color = colors[index % colors.length];
              return GlassmorphicCategoryCard(
                category: categoryList[index],
                backgroundColor: color,
              );
            },
            itemCount: categoryList.length,
          ),
        ),
      ],
    );
  }
}

class GlassmorphicCategoryCard extends StatelessWidget {
  final Category category;
  final Color backgroundColor;
  
  const GlassmorphicCategoryCard({
    Key? key,
    required this.category,
     this.backgroundColor = const Color.fromARGB(245, 245, 110, 15), // Default color if none provided
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => category.destinationScreen,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
               color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
             
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    category.thumbnail,
                    height: kCategoryCardImageSize,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  category.definition,
                  style:  const   TextStyle(
                    fontSize: 11,
                  ), textAlign: TextAlign.center,
                ),
                // Text(
                //   "${category.noOfCourses.toString()} courses",
                //   style: Theme.of(context).textTheme.bodySmall,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
