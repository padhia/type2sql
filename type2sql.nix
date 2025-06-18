{
  lib,
  buildPythonPackage,
  setuptools,
  pythonOlder,
  pytest,
}:

buildPythonPackage {
  pname = "type2sql";
  version = "0.1.0";
  src = ./.;
  pyproject = true;

  disabled = pythonOlder "3.12";

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytest
  ];

  meta = with lib; {
    homepage = "https://github.com/padhia/type2sql";
    description = "Code generator for Python classes to flattened relational SQL Table types";
    maintainers = with maintainers; [
      padhia
    ];
  };
}
