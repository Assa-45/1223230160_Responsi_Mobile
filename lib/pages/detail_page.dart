// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../models/anime_model.dart';
// import '../providers/app_state.dart';
// import 'fav_page.dart';

// class AnimeDetailPage extends StatefulWidget {
//   final Anime anime;

  // const AnimeDetailPage({super.key, required this.anime});

//   @override
//   State<AnimeDetailPage> createState() => _AnimeDetailPageState();
// }

// class _AnimeDetailPageState extends State<AnimeDetailPage> {
//   int _quantity = 1;
//   int _selectedImageIndex = 0;
//   late PageController _pageController;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   Anime get a => widget.anime;

//   void _increment() {
//     setState(() => _quantity++);
//   }

//   void _decrement() {
//     setState(() => _quantity--);
//   }

//   void _addToFav(BuildContext context) {
//     context.read<AppState>().addToFav(a, _quantity);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.all(16),
//         backgroundColor: const Color(0xFF1E1E32),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//         content: Row(
//           children: [
//             const Icon(Icons.check_circle_rounded, color: Color(0xFF6C63FF), size: 20),
//             const SizedBox(width: 10),
//             Text(
//               '$_quantity item ditambahkan ke Cart!',
//               style: GoogleFonts.dmSans(color: Colors.white, fontSize: 13),
//             ),
//           ],
//         ),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final images = a.images.isNotEmpty ? a.images : [a.thumbnail];

//     return Scaffold(
//       backgroundColor: const Color(0xFF0D0D0D),
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 340,
//             pinned: true,
//             backgroundColor: const Color(0xFF0D0D0D),
//             leading: GestureDetector(
//               onTap: () => Navigator.pop(context),
//               child: Container(
//                 margin: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(Icons.arrow_back_ios_new_rounded,
//                     color: Colors.white, size: 18),
//               ),
//             ),
//             actions: [
//               Consumer<AppState>(
//                 builder: (_, appState, __) => Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     GestureDetector(
//                       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage())),
//                       child: Container(
//                         margin: const EdgeInsets.all(8),
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.black54,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Icon(Icons.shopping_bag_outlined,
//                             color: Colors.white, size: 22),
//                       ),
//                     ),
//                     if (appState.favItemCount > 0)
//                       Positioned(
//                         top: 4,
//                         right: 4,
//                         child: Container(
//                           padding: const EdgeInsets.all(3),
//                           decoration: const BoxDecoration(
//                             color: Color(0xFF6C63FF),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Text(
//                             '${appState.favItemCount}',
//                             style: GoogleFonts.dmSans(
//                               fontSize: 9,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//             flexibleSpace: FlexibleSpaceBar(
//               background: Stack(
//                 children: [
//                   PageView.builder(
//                     controller: _pageController,
//                     itemCount: images.length,
//                     onPageChanged: (i) => setState(() => _selectedImageIndex = i),
//                     itemBuilder: (_, i) => Image.network(
//                       images[i],
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) => Container(
//                         color: const Color(0xFF1A1A2E),
//                         child: const Icon(Icons.image_not_supported_outlined,
//                             color: Colors.white24, size: 48),
//                       ),
//                     ),
//                   ),
//                   // Gradient overlay
//                   Positioned.fill(
//                     child: DecoratedBox(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.transparent,
//                             const Color(0xFF0D0D0D).withOpacity(0.8),
//                           ],
//                           stops: const [0.6, 1.0],
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Page indicator
//                   if (images.length > 1)
//                     Positioned(
//                       bottom: 16,
//                       left: 0,
//                       right: 0,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: List.generate(
//                           images.length,
//                           (i) => AnimatedContainer(
//                             duration: const Duration(milliseconds: 200),
//                             margin: const EdgeInsets.symmetric(horizontal: 3),
//                             width: i == _selectedImageIndex ? 20 : 6,
//                             height: 6,
//                             decoration: BoxDecoration(
//                               color: i == _selectedImageIndex
//                                   ? const Color(0xFF6C63FF)
//                                   : Colors.white38,
//                               borderRadius: BorderRadius.circular(3),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),

//           // Content
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Category & Brand
//                   Row(
//                     children: [
//                       _buildTag(p.category, const Color(0xFF6C63FF)),
//                       const SizedBox(width: 8),
//                       _buildTag(p.brand, const Color(0xFF2A2A40)),
//                     ],
//                   ),
//                   const SizedBox(height: 14),

//                   // Title
//                   Text(
//                     p.title,
//                     style: GoogleFonts.dmSans(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                       height: 1.3,
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // Rating & Stock
//                   Row(
//                     children: [
//                       ...List.generate(5, (i) {
//                         return Icon(
//                           i < p.rating.floor()
//                               ? Icons.star_rounded
//                               : (i < p.rating ? Icons.star_half_rounded : Icons.star_outline_rounded),
//                           color: const Color(0xFFFFC107),
//                           size: 18,
//                         );
//                       }),
//                       const SizedBox(width: 8),
//                       Text(
//                         '${p.rating.toStringAsFixed(1)} rating',
//                         style: GoogleFonts.dmSans(
//                           fontSize: 13,
//                           color: Colors.white54,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                         decoration: BoxDecoration(
//                           color: p.stock > 10
//                               ? Colors.green.withOpacity(0.1)
//                               : Colors.orange.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Text(
//                           p.stock > 10 ? 'Stok Tersedia' : 'Stok Terbatas (${p.stock})',
//                           style: GoogleFonts.dmSans(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600,
//                             color: p.stock > 10 ? Colors.green : Colors.orange,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 20),

//                   // Price
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         '\$${p.discountedPrice.toStringAsFixed(2)}',
//                         style: GoogleFonts.dmSans(
//                           fontSize: 28,
//                           fontWeight: FontWeight.w800,
//                           color: Colors.white,
//                         ),
//                       ),
//                       if (p.discountPercentage > 0) ...[
//                         const SizedBox(width: 10),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '\$${p.price.toStringAsFixed(2)}',
//                               style: GoogleFonts.dmSans(
//                                 fontSize: 14,
//                                 color: Colors.white30,
//                                 decoration: TextDecoration.lineThrough,
//                               ),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 6, vertical: 2),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFFF6584).withOpacity(0.15),
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                               child: Text(
//                                 'Hemat ${p.discountPercentage.toStringAsFixed(0)}%',
//                                 style: GoogleFonts.dmSans(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w700,
//                                   color: const Color(0xFFFF6584),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ],
//                   ),

//                   const SizedBox(height: 24),

//                   // Divider
//                   Divider(color: Colors.white.withOpacity(0.07)),
//                   const SizedBox(height: 20),

//                   // Description
//                   Text(
//                     'Deskripsi Produk',
//                     style: GoogleFonts.dmSans(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     p.description,
//                     style: GoogleFonts.dmSans(
//                       fontSize: 14,
//                       color: Colors.white54,
//                       height: 1.6,
//                     ),
//                   ),

//                   const SizedBox(height: 28),

//                   // Product Info Grid
//                   _buildInfoGrid(),

//                   const SizedBox(height: 28),

//                   Divider(color: Colors.white.withOpacity(0.07)),
//                   const SizedBox(height: 20),

//                   // Quantity Selector
//                   Text(
//                     'Jumlah',
//                     style: GoogleFonts.dmSans(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   _buildQtySelector(),

//                   const SizedBox(height: 10),

//                   Text(
//                     'Stok tersedia: ${p.stock} item',
//                     style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white38),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),

//       // Bottom Add to Cart
//       bottomNavigationBar: _buildBottomBar(),
//     );
//   }

//   Widget _buildTag(String label, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         label,
//         style: GoogleFonts.dmSans(
//           fontSize: 11,
//           fontWeight: FontWeight.w600,
//           color: color == const Color(0xFF2A2A40) ? Colors.white60 : color,
//           letterSpacing: 0.3,
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoGrid() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF13131F),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.withOpacity(0.06)),
//       ),
//       child: Row(
//         children: [
//           _buildInfoItem(Icons.inventory_2_outlined, 'Stok', '${p.stock}'),
//           _buildInfoDivider(),
//           _buildInfoItem(Icons.category_outlined, 'Kategori', p.category),
//           _buildInfoDivider(),
//           _buildInfoItem(Icons.discount_outlined, 'Diskon',
//               '${p.discountPercentage.toStringAsFixed(0)}%'),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoItem(IconData icon, String label, String value) {
//     return Expanded(
//       child: Column(
//         children: [
//           Icon(icon, color: const Color(0xFF6C63FF), size: 20),
//           const SizedBox(height: 6),
//           Text(
//             label,
//             style: GoogleFonts.dmSans(fontSize: 11, color: Colors.white38),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             value,
//             style: GoogleFonts.dmSans(
//               fontSize: 12,
//               fontWeight: FontWeight.w700,
//               color: Colors.white,
//             ),
//             textAlign: TextAlign.center,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoDivider() {
//     return Container(width: 1, height: 40, color: Colors.white.withOpacity(0.07));
//   }

//   Widget _buildQtySelector() {
//     return Row(
//       children: [
//         _buildQtyButton(Icons.remove_rounded, _quantity > 1 ? _decrement : null),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Text(
//             '$_quantity',
//             style: GoogleFonts.dmSans(
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         _buildQtyButton(Icons.add_rounded, _quantity < p.stock ? _increment : null),
//       ],
//     );
//   }

//   Widget _buildQtyButton(IconData icon, VoidCallback? onTap) {
//     final enabled = onTap != null;
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 150),
//         width: 44,
//         height: 44,
//         decoration: BoxDecoration(
//           color: enabled ? const Color(0xFF1A1A2E) : const Color(0xFF111118),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: enabled
//                 ? const Color(0xFF6C63FF).withOpacity(0.3)
//                 : Colors.white.withOpacity(0.05),
//           ),
//         ),
//         child: Icon(
//           icon,
//           color: enabled ? const Color(0xFF6C63FF) : Colors.white24,
//           size: 20,
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomBar() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
//       decoration: BoxDecoration(
//         color: const Color(0xFF0D0D0D),
//         border: Border(
//           top: BorderSide(color: Colors.white.withOpacity(0.06)),
//         ),
//       ),
//       child: Row(
//         children: [
//           // Total price
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Total',
//                 style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white38),
//               ),
//               Text(
//                 '\$${(p.discountedPrice * _quantity).toStringAsFixed(2)}',
//                 style: GoogleFonts.dmSans(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w800,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(width: 20),

//           // Add to Cart Button
//           Expanded(
//             child: SizedBox(
//               height: 52,
//               child: ElevatedButton(
//                 onPressed: () => _addToCart(context),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF6C63FF),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.shopping_bag_outlined, size: 20),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Tambah ke Cart',
//                       style: GoogleFonts.dmSans(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }