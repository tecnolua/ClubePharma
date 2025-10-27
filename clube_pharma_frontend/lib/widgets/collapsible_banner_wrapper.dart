import 'package:flutter/material.dart';

class CollapsibleBannerWrapper extends StatefulWidget {
  final String title;
  final String subtitle;
  final Color gradientStart;
  final Color gradientEnd;
  final Widget? trailing;
  final Widget child;

  const CollapsibleBannerWrapper({
    super.key,
    required this.title,
    required this.subtitle,
    required this.gradientStart,
    required this.gradientEnd,
    this.trailing,
    required this.child,
  });

  @override
  State<CollapsibleBannerWrapper> createState() => _CollapsibleBannerWrapperState();
}

class _CollapsibleBannerWrapperState extends State<CollapsibleBannerWrapper> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    // Padding responsivo: mobile (32px) vs web/desktop (maior padding baseado na largura)
    final double horizontalPadding = screenWidth > 600
        ? (screenWidth * 0.15).clamp(80.0, 300.0) // Web: 15% da largura, mín 80px, máx 300px
        : 32.0; // Mobile: 32px

    // Calcula o progresso do scroll (0 = expandido, 1 = colapsado)
    final double scrollProgress = (_scrollOffset / 80).clamp(0.0, 1.0);

    // Altura do banner: 80 quando expandido, 60 quando colapsado
    final double bannerHeight = 80 - (20 * scrollProgress);

    // Tamanho da fonte do título: 24 quando expandido, 18 quando colapsado
    final double titleSize = 24 - (6 * scrollProgress);

    // Opacidade da subtitle: 1 quando expandido, 0 quando colapsado (fade out mais rápido)
    final double subtitleOpacity = (1 - (scrollProgress * 2.0)).clamp(0.0, 1.0);

    return Column(
      children: [
        // Banner animado
        AnimatedContainer(
          duration: const Duration(milliseconds: 0),
          width: double.infinity,
          height: bannerHeight,
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14 - (6 * scrollProgress),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.gradientStart,
                widget.gradientEnd,
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24 * (1 - scrollProgress)),
              bottomRight: Radius.circular(24 * (1 - scrollProgress)),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitleOpacity > 0.1) ...[
                    SizedBox(height: 4 * subtitleOpacity),
                    Opacity(
                      opacity: subtitleOpacity,
                      child: Text(
                        widget.subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(255, 255, 255, 0.9),
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              if (widget.trailing != null)
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(child: widget.trailing!),
                ),
            ],
          ),
        ),

        // Conteúdo com scroll e espaçamento
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : Colors.grey.shade50,
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 20),
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}
