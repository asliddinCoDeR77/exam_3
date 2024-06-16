import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Promoccode extends StatefulWidget {
  const Promoccode({super.key});

  @override
  State<Promoccode> createState() => _PromoccodeState();
}

class _PromoccodeState extends State<Promoccode> {
  void _showPromoCodeSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      isDismissible: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Promo Code',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Color(0xff222B45)),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Promo Code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  backgroundColor: const Color(0xff222B45),
                  minimumSize: const Size(383, 48),
                ),
                onPressed: () {},
                child: const Text(
                  'Apply',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showPromoCodeSheet2() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset('assets/icons/close.svg'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Here’s 50% off for\nyou, and 10% for a friend',
                style: TextStyle(
                  color: Color(0xff222B45),
                  fontWeight: FontWeight.w600,
                  fontSize: 34,
                ),
              ),
              const SizedBox(height: 24),
              Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      'assets/images/food.png',
                      width: double.infinity,
                      height: 390,
                    ),
                  ),
                  Positioned(
                    top: -50,
                    right: 30,
                    child: Image.asset(
                      'assets/images/offer.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              const Center(
                child: Text(
                  'DJFGH84',
                  style: TextStyle(
                      color: Color(0xff101426),
                      fontWeight: FontWeight.w600,
                      fontSize: 34),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: BeveledRectangleBorder(
                        side: const BorderSide(color: Color(0xff222B45)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      backgroundColor: Colors.white,
                      minimumSize: const Size(167, 48),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Copy',
                      style: TextStyle(
                        color: Color(0xff222B45),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: BeveledRectangleBorder(
                        side: const BorderSide(color: Color(0xff222B45)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      backgroundColor: const Color(0xff222B45),
                      minimumSize: const Size(167, 48),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Share discount',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: SvgPicture.asset('assets/icons/arrow_back.svg'),
        ),
        title: const Text(
          'Promo code',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xff222B45),
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: SvgPicture.asset('assets/icons/promocode.svg'),
              title: const Text(
                'Enter promo code',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xff222B45),
                  fontSize: 16,
                ),
              ),
              trailing: SvgPicture.asset('assets/icons/arrow_forward.svg'),
              onTap: _showPromoCodeSheet,
            ),
            ListTile(
              leading: SvgPicture.asset('assets/icons/promo.svg'),
              title: const Text(
                'Get discount',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xff222B45),
                  fontSize: 16,
                ),
              ),
              trailing: SvgPicture.asset('assets/icons/arrow_forward.svg'),
              onTap: _showPromoCodeSheet2,
            ),
            const SizedBox(
              height: 720,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                backgroundColor: const Color(0xff222B45),
                minimumSize: const Size(383, 48),
              ),
              onPressed: () {},
              child: const Text(
                'Share discount',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
