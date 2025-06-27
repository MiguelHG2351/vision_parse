import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vision_parse/blocs/bloc/auth_bloc.dart';
import 'package:vision_parse/utils/app_ads.dart';
import 'package:vision_parse/widgets/history_tab.dart';
import 'package:vision_parse/widgets/sliver_appbar.dart';
import 'package:vision_parse/widgets/analyze_tab.dart';

class HomePage extends StatefulWidget {
  static const String pathName = 'HomePage';
  static const String path = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<bool> _isDisabled = [false, true];
  InterstitialAd? _interstitialAd;

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AppAds.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _interstitialAd = ad;
          });
          _setFullScreenContentCallback(ad);
        },
        onAdFailedToLoad: (error) {
          _interstitialAd?.dispose();
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void _setFullScreenContentCallback(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        // El usuario cerró el anuncio → libera y carga uno nuevo
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        debugPrint('Error mostrando interstitial: $error');
        _createInterstitialAd();
      },
    );
  }

  onTap() async {
    if (_isDisabled[_tabController.index]) {
      int index = _tabController.previousIndex;
      setState(() {
        _tabController.index = index;
      });
      // mostrar ad
      if (_interstitialAd != null) {
        _interstitialAd!.show();
      } else {
        debugPrint('Interstitial ad is not ready yet.');
      }
      // Mostrar modal para actualizar a premium
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Función Premium'),
          content: Text('Actualiza a Premium para acceder al historial.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/subscription');
              },
              child: Text('Actualizar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(onTap);
    final isPremium = context.read<AuthBloc>().state.profile.paymentMethod.isNotEmpty;
    _isDisabled = [false, !isPremium];
  }

  @override
  void dispose() {
    _tabController.removeListener(onTap);
    _tabController.dispose();
    print('InterstitialAd disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.profile.paymentMethod.isNotEmpty) {
          _isDisabled = [false, false];
        } else {
          _isDisabled = [false, true];
          _createInterstitialAd();
        }
      },
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (
              BuildContext context,
              bool innerBoxIsScrolled,
            ) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    context,
                  ),
                  sliver: SliverPersistentHeader(
                    delegate: SliverAppbar(tabController: _tabController, interstitialAd: _interstitialAd),
                    floating: false,
                    pinned: true,
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [AnalyzeTab(interstitialAd: _interstitialAd), HistoryTab()],
            ),
          ),
        ),
      ),
    );
  }
}
