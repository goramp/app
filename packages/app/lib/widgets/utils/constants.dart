import 'package:flutter/material.dart';

const kTopBorderRadius = const BorderRadius.only(
    topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0));
const kInputBorderRadius = const BorderRadius.all(Radius.circular(4.0));
const kListBorderRadius = const BorderRadius.all(Radius.circular(4.0));
const kBorderRadius = const BorderRadius.all(Radius.circular(6.0));
const kMediumBorderRadius = const BorderRadius.all(Radius.circular(16.0));
const kinputFieldHeight = 48.0;
const kEventInputBorder = const OutlineInputBorder(
    borderRadius: kInputBorderRadius, borderSide: BorderSide.none);
const kEventOutlineInputBorder = const OutlineInputBorder(
    borderRadius: kInputBorderRadius);

const String kTrimmerHeroTag = "TrimmerHero";
const String kCallLinkPreviewTag = "call_link_preview_tag";
const String kCallPreviewTag = "schedule_preview_tag";

const double TILE_ITEM_WIDTH = 162;
const double TILE_ITEM_WIDTH_LARGE = 192;

const kHorizontalListPadding =
    const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0, right: 0.0);

// Sentinel value for the system text scale factor option.
const double systemTextScaleFactorOption = -1;

const MY_TABS = ['call_links', 'likes'];

const MY_WALLETS = ['tokens', 'passes', 'cards', 'payments'];
