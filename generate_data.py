import kagglehub

# Download latest version
path = kagglehub.dataset_download("affiliatematic/amazon-affiliate-marketing-performance-dataset")

print("Path to dataset files:", path)