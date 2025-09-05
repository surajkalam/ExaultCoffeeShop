import 'package:flutter/material.dart';
import 'package:scratch_card/scratch_card.dart';

class ScratchCardDemo extends StatelessWidget {
  const ScratchCardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,  // Fixed card height
                width: 300,   // Fixed card width
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.amber,
                  boxShadow: [  // Add shadow for depth
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ScratchCard(
                    stockSize: 70,  // Size of the scratch brush
                    scratchColor: Colors.pink,  // Scratch layer color
                    child: Center(
                      child: Image(image: AssetImage('Assets/Images/scratch2.png'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,  // Fixed card height
                width: 300,   // Fixed card width
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.amber,
                  boxShadow: [  // Add shadow for depth
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ScratchCard(
                    stockSize: 70,  // Size of the scratch brush
                    scratchColor: Colors.pink,  // Scratch layer color
                    child: Center(
                      child: Image(image: AssetImage('Assets/Images/scratch1.jpg'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,  // Fixed card height
                width: 300,   // Fixed card width
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.amber,
                  boxShadow: [  // Add shadow for depth
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ScratchCard(
                    stockSize: 70,  // Size of the scratch brush
                    scratchColor: Colors.pink,  // Scratch layer color
                    child: Center(
                      child: Image(image: AssetImage('Assets/Images/scratch3.png'),
                      ),
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