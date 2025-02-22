import * as admin from 'firebase-admin';

if (!admin.apps.length) {
    admin.initializeApp();
}

export * from './add_notification';
export * from './delete_comment';
export * from './delete_notification_job';
export * from './recursive_delete_account';
export * from './recursive_delete_post';
export * from './send_push_notification';
export * from './update_comment_count';
export * from './update_like_count';
export * from './update_profile';
