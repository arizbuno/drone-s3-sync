# Drone AWS S3 Synchronisation Pipeline Plugin

This plugin for a [Drone](https://drone.io) Pipeline utilises the `aws s3 sync`
command to synchronise files and folders with a selected Amazon S3 bucket.

This plugin is loosely based on the original
[drone-s3-sync](https://github.com/joshdvir/drone-s3-sync) repository by
[joshdvir](https://github.com/joshdvir), but has been expanded with additional
checking, SSE support, and the ability to assume a Role before running the `aws`
CLI commands.

## Options

All options are managed below a `settings` key:

* `aws_access_key_id` (Optional): Amazon AWS Access Key credential.
* `aws_secret_access_key` (Optional): Amazon AWS Secret Access Key credential.
* `aws_assume_role` (Optional): The full ARN of a role to be assumed before
  running the synchronisation (and invalidating the CloudFront distribution, if
  set).
* `bucket` (**Required**): The name (but not the domain name) of the bucket to
  upload to.
* `region` (Optional): The region the bucket is within, as so to connect to it
  for the synchronisation (defaults to `us-east-1` if not set).
* `acl` (Optional): Sets the ACL for the object when the command is performed
  (e.g. `private`, `public-read`, `public-read-write`, `authenticated-read`,
  `aws-exec-read`, `bucket-owner-read`, `bucket-owner-full-control`, and
  `log-delivery-write`).
* `sse` (Optional): Sets the SSE parameter for the upload, if required, to
  enable encryption of the files at rest in the S3 bucket.
* `source` (Optional): The location of folder (defaults to `.`, the current
  directory) to synchronise, either absolute or relative to the current working
  directory (i.e. the root of the repository).
* `target` (Optional): The target folder to upload the files and folders in
  `source` to inside your S3 bucket (defaults to `/`).
* `exclude` (Optional): Exclude all files or objects from the synchronisation
  that match the specified pattern.
* `include` (Optional): Don't exclude files or objects from the synchronisation
  that match the specified pattern.
* `delete` (Optional): Set to `true` to configure the synchronisation to delete
  files in the target that are not found in the source (defaults to `false`).
* `show_only_errors` (Optional): Set to `true` to only show errors during the
  synchronisation, rather than every file uploaded (defaults to `false`).
* `cloudfront_distribution_id` (Optional): The CloudFront Distribution ID to
  invalidate after synchronising, with the `target` used as the root of the
  invalidation path (by default this will be `/*`).

## Example

Use the following as an example configuration to use to synchronise files to S3
from within your `.drone.yml` files:

```yaml
pipeline:
  synchronise-files:
    image: jonathanio/drone-s3-sync:latest
    settings:
      aws_assume_role: arn:aws:iam::123456789012:role/MyDeploymentRole
      bucket: my-example-bucket
      region: eu-west-2
      acl: public-read
      sse: AES256
      source: public/
      target: /
      exclude: "*.log"
      delete: true
      cloudfront_distribution_id: "9c5785d3ece6a9cdefa4"
    when:
      event: push
      branch: master
```

## Licence

MIT

## Author

* Jonathan Wright <<jon@than.io>>

and based upon work by [joshdvir](https://github.com/joshdvir).
