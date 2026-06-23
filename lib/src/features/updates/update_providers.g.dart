// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AvailableUpdate)
final availableUpdateProvider = AvailableUpdateProvider._();

final class AvailableUpdateProvider
    extends $NotifierProvider<AvailableUpdate, AppRelease?> {
  AvailableUpdateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableUpdateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableUpdateHash();

  @$internal
  @override
  AvailableUpdate create() => AvailableUpdate();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppRelease? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppRelease?>(value),
    );
  }
}

String _$availableUpdateHash() => r'10049d1b7c5c84607f848c3bc3e4815912278c3f';

abstract class _$AvailableUpdate extends $Notifier<AppRelease?> {
  AppRelease? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppRelease?, AppRelease?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppRelease?, AppRelease?>,
              AppRelease?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
