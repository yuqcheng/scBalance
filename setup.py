import setuptools

setuptools.setup(
    name = "scBalance",
    version = "1.1.0",
    description = "scBalance, a neural network framework, "
                  "provides a fast and reliable tools for scRNA-seq profile auto-annotation.",
    license = "MIT Licence",
    python_requires=">=3.5.0",
    packages=setuptools.find_packages(),
    url = "https://github.com/yuqcheng/scBalance",
    author = "Yuqi Cheng",
    author_email = "yuc4009@med.cornell.edu"
)