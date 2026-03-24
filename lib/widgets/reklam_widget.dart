import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import '../models/reklam_model.dart';

class ReklamWidget extends Widget {
  final Reklam? reklam;
  final double height;

  const ReklamWidget({
    super.key,
    required this.reklam,
    this.height = 100,
  });

  @override
  Element createElement() => _ReklamElement(this);
}

class _ReklamElement extends ComponentElement {
  _ReklamElement(ReklamWidget widget) : super(widget);

  @override
  ReklamWidget get widget => super.widget as ReklamWidget;

  @override
  Widget build() {
    if (widget.reklam == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: widget.height,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
      ),
      child: widget.reklam!.isImage ? _buildImageReklam() : _buildCodeReklam(),
    );
  }

  Widget _buildImageReklam() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: widget.reklam!.imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
          child: const Center(child: Icon(Icons.image_not_supported)),
        ),
      ),
    );
  }

  Widget _buildCodeReklam() {
    // Google AdSense veya HTML kodu için
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          'Reklam Alanı',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
