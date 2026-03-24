import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import '../models/haber_model.dart';

class MansetCarousel extends StatefulWidget {
  final List<Haber> haberler;
  final Function(Haber) onTap;

  const MansetCarousel({
    super.key,
    required this.haberler,
    required this.onTap,
  });

  @override
  State<MansetCarousel> createState() => _MansetCarouselState();
}

class _MansetCarouselState extends State<MansetCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.haberler.isNotEmpty) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < widget.haberler.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.haberler.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.haberler.length,
            itemBuilder: (context, index) {
              final haber = widget.haberler[index];
              return GestureDetector(
                onTap: () => widget.onTap(haber),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Resim
                        if (haber.resim != null)
                          CachedNetworkImage(
                            imageUrl: haber.resim!,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported,
                                  size: 50),
                            ),
                          ),

                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),

                        // Başlık
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (haber.kategori != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red[700],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      haber.kategori!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Text(
                                  haber.baslik,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    height: 1.3,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Dots indicator
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.haberler.length,
            (index) => Container(
              width: _currentPage == index ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color:
                    _currentPage == index ? Colors.red[700] : Colors.grey[400],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
