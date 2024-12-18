import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:premiere_league_v2/components/config/app_const.dart';
import 'package:premiere_league_v2/components/widget/app_observer_builder_widget.dart';
import 'package:premiere_league_v2/screens/favorite/controller/favorite_controller.dart';
import 'package:premiere_league_v2/screens/favorite/model/fav_club_model.dart';
import 'package:premiere_league_v2/screens/favorite/presentation/liked_equipment_popup.dart';
import 'package:premiere_league_v2/screens/home/controller/home_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late FavoriteController _favoriteController;
  late HomeController _controller;

  @override
  void initState() {
    super.initState();
    _favoriteController = FavoriteController();

    _favoriteController.favoriteClubCommand.execute();

    _controller = HomeController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refresh() async {
    _favoriteController.favoriteClubCommand.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _contentBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            builder: (context) =>
                LikedEquipmentPopup(controller: _favoriteController),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppConst.imageBackground), fit: BoxFit.fill),
            color: Colors.deepPurple,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(100),
              topRight: Radius.circular(100),
            ),
          ),
          child: const Icon(
            Ionicons.shirt,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.favoriteTitle),
      centerTitle: true,
    );
  }

  Widget _contentBody() {
    return AppObserverBuilder(
      commandQuery: _favoriteController.favoriteClubCommand,
      onLoading: () => const Center(child: CircularProgressIndicator()),
      child: (data) {
        final List<FavClubModel> team = List<FavClubModel>.from(data);

        if (team.isEmpty) {
          return Center(
              child: Text(AppLocalizations.of(context)!.favoriteError));
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            itemCount: team.length,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              return _itemCardFC(team[index]);
            },
          ),
        );
      },
    );
  }

  Widget _itemCardFC(FavClubModel footballClub) {
    final imageUrl = footballClub.badge ?? '';

    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListTile(
        onTap: () => _onTapItemFootball(footballClub),
        leading: Hero(
          tag: footballClub.team ?? 'default-tag',
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => Image.asset(
              AppConst.clubLogoPlaceHolder,
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.fill,
            fadeInDuration: const Duration(milliseconds: 300),
          ),
        ),
        title: Text(
          footballClub.team!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: IconButton(
          iconSize: 30,
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () =>
              _favoriteController.removeFromFavorites(footballClub),
        ),
      ),
    );
  }

  void _onTapItemFootball(FavClubModel team) {
    if (team.team != null && team.badge != null) {
      _controller.onTapItemFootBall(team.team!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.unableToLoad)),
      );
    }
  }
}
