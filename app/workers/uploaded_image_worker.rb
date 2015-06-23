class UploadedImageWorker < RetryWorker
  WORKERS = 4

  from_queue "uploaded_images",
             threads: 1,
             timeout_job_after: 60,
             prefetch: 1
end
