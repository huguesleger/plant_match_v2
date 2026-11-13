sealed class StorageCachePolicy {
  const StorageCachePolicy();
}

class ImmutableStorageCache extends StorageCachePolicy {
  const ImmutableStorageCache();
}

class DefaultStorageCache extends StorageCachePolicy {
  const DefaultStorageCache();
}
