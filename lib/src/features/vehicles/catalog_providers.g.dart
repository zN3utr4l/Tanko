// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(catalogMakes)
final catalogMakesProvider = CatalogMakesProvider._();

final class CatalogMakesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  CatalogMakesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogMakesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogMakesHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return catalogMakes(ref);
  }
}

String _$catalogMakesHash() => r'cca001cf9a965b2cc9d54144d14e43610b7ce317';

@ProviderFor(catalogModels)
final catalogModelsProvider = CatalogModelsFamily._();

final class CatalogModelsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CatalogModel>>,
          List<CatalogModel>,
          FutureOr<List<CatalogModel>>
        >
    with
        $FutureModifier<List<CatalogModel>>,
        $FutureProvider<List<CatalogModel>> {
  CatalogModelsProvider._({
    required CatalogModelsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'catalogModelsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$catalogModelsHash();

  @override
  String toString() {
    return r'catalogModelsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CatalogModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CatalogModel>> create(Ref ref) {
    final argument = this.argument as String;
    return catalogModels(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CatalogModelsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$catalogModelsHash() => r'1bdab4802f7b587e5aedc10fa2aa30178a9e4c30';

final class CatalogModelsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CatalogModel>>, String> {
  CatalogModelsFamily._()
    : super(
        retry: null,
        name: r'catalogModelsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CatalogModelsProvider call(String make) =>
      CatalogModelsProvider._(argument: make, from: this);

  @override
  String toString() => r'catalogModelsProvider';
}
