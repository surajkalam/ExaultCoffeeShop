import 'package:coffee_shop/Features/Profile/Provider/scratch_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
class ScratchCardsScreen extends ConsumerWidget {
  const ScratchCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scratchCards = ref.watch(scratchCardsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('My Scratch Cards')),
      body: scratchCards.isEmpty
          ? Center(child: Text('No scratch cards yet!'))
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.9,
              ),
              padding: EdgeInsets.all(8),
              itemCount: scratchCards.length,
              itemBuilder: (context, index) {
                final card = scratchCards[index];
                return Stack(
                  children: [
                    // Card Background
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.grey,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image(
                            image: AssetImage(card.imagePath),
                            height: 150,
                            width: 150,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    // Scratch Cover - Only shown when NOT scratched
                    if (!card.isScratched)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 120, // Height of the covered area
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.grey,
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: Offset(0, 2),
                            ),
                          ],
                          ),
                          child: Center(
                            child: Lottie.asset(
                              'Assets/Icons/Scratch Card.json',
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                      ),
                    // Status Badge
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: card.isScratched
                              ? Colors.green
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          card.isScratched ? 'OPENED' : 'SCRATCH ME',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
