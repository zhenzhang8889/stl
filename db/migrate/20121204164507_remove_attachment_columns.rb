class RemoveAttachmentColumns < ActiveRecord::Migration
  def up
  	remove_column :posts, :image_content_type
  	remove_column :posts, :image_file_size
  	remove_column :posts, :image_file_name
  	remove_column :posts, :image_updated_at
  	remove_column :posts, :post_video_content_type
  	remove_column :posts, :post_video_file_name
  	remove_column :posts, :post_video_file_size
  	remove_column :posts, :post_video_updated_at

  	remove_column :workouts, :photo_content_type
  	remove_column :workouts, :photo_file_name
  	remove_column :workouts, :photo_file_size 
  	remove_column :workouts, :photo_updated_at 
  	remove_column :workouts, :workout_video_file_name
  	remove_column :workouts, :workout_video_content_type
  	remove_column :workouts, :workout_video_file_size
  	remove_column :workouts, :workout_video_updated_at


  	remove_column :statuses, :pic_file_name
  	remove_column :statuses, :pic_content_type
  	remove_column :statuses, :pic_file_size 
  	remove_column :statuses, :pic_updated_at
  	remove_column :statuses, :status_video_file_name
  	remove_column :statuses, :status_video_content_type
  	remove_column :statuses, :status_video_file_size
  	remove_column :statuses, :status_video_updated_at
  end

  def down
  end
end