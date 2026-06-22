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
          AsyncValue<List<CatalogMake>>,
          List<CatalogMake>,
          FutureOr<List<CatalogMake>>
        >
    with
        $FutureModifier<List<CatalogMake>>,
        $FutureProvider<List<CatalogMake>> {
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
  $FutureProviderElement<List<CatalogMake>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CatalogMake>> create(Ref ref) {
    return catalogMakes(ref);
  }
}

String _$catalogMakesHash() => r'a29433a88b433f4ccdf8cd01396ae9932edb1183';

@ProviderFor(catalogModels)
final catalogModelsProvider = CatalogModelsFamily._();

final class CatalogModelsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
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
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
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

String _$catalogModelsHash() => r'ed2bd734908d1ec333f2770e6e45ba9025d7c680';

final class CatalogModelsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<String>>, String> {
  CatalogModelsFamily._()
    : super(
        retry: null,
        name: r'catalogModelsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CatalogModelsProvider call(String makeId) =>
      CatalogModelsProvider._(argument: makeId, from: this);

  @override
  String toString() => r'catalogModelsProvider';
}

@ProviderFor(catalogTrims)
final catalogTrimsProvider = CatalogTrimsFamily._();

final class CatalogTrimsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CatalogTrim>>,
          List<CatalogTrim>,
          FutureOr<List<CatalogTrim>>
        >
    with
        $FutureModifier<List<CatalogTrim>>,
        $FutureProvider<List<CatalogTrim>> {
  CatalogTrimsProvider._({
    required CatalogTrimsFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'catalogTrimsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$catalogTrimsHash();

  @override
  String toString() {
    return r'catalogTrimsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<CatalogTrim>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CatalogTrim>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return catalogTrims(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is CatalogTrimsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$catalogTrimsHash() => r'187b580ab9387120dc99d6ac80c393e9354597e9';

final class CatalogTrimsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<CatalogTrim>>,
          (String, String)
        > {
  CatalogTrimsFamily._()
    : super(
        retry: null,
        name: r'catalogTrimsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CatalogTrimsProvider call(String makeId, String model) =>
      CatalogTrimsProvider._(argument: (makeId, model), from: this);

  @override
  String toString() => r'catalogTrimsProvider';
}
