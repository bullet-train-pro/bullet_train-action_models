# Upgrading from 1.1 to 1.2

## Background

We've made a major improvement to the function of `Actions::TargetsMany` and `Actions::PerformsExport` in an attempt to improve the resiliency of long-running actions.

- The Sidekiq worker now limits itself to processing 100 target records per job before completing and dispatching a new Sidekiq job to continue the process. 
  - The page size can be overloaded per action by redefining the `page_size` method.
- If an exception is thrown while processing an individual target record, it is caught instead of breaking the job and added to `failed_ids`.
- An independent health check job is dispatched at the same time the worker starts and checks every 30 seconds whether the action is still processing records. If it hasn't completed processing a record in the last 45 seconds, the job is automatically restarted.
  - Health check frequency and timeout can be overloaded per action by redefining the `health_check_frequency` and `health_check_timeout` methods (returning values like `30.seconds` and `45.seconds`.)

## Migrating Existing Action Models

### Database Migrations
Any Action Models that use `Actions::TargetMany` or `Actions::PerformsExport` need database migrations to add `failed_ids:jsonb` and `last_completed_id:integer` columns before upgrading. The default value for `failed_ids` should be `[]` and the default value for `last_completed_id` should be `0`.

If you're on MySQL, it's a `json` column (and not `jsonb`) and you have to set the default value for `failed_ids` using an `after_initialize` block instead of setting a default value for the column at the database level. You can see the existing `after_initialize` block in your Action Model for an example of how to do this.

### Code Review
You should also review the following upstream PRs to and make sure you understand the changes to the underlying code and make sure no workarounds you may have implemented in your Action Models would be affected by this. 

 - For targets many and export actions: https://github.com/bullet-train-pro/bullet_train-action_models/pull/46 
 - For export actions exclusively: https://github.com/bullet-train-pro/bullet_train-action_models/pull/52

### Manual Testing
Test your Action Models thoroughly after upgrading. In particular, we recommend testing all actions with both less than 100 target objects and more than 100 target objects.
