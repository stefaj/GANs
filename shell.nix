with import <nixpkgs> {};
with pkgs.python36Packages;

let
   gym = buildPythonPackage rec {
     pname = "gym";
     version = "0.9.4";
     name = "${pname}-${version}";

     src = pkgs.fetchurl {
       url = "https://pypi.python.org/packages/f8/9f/b50f4c04a97e316ebfccae3104e5edbfe7bc1c687ee9ebeca6fa6343d197/gym-0.9.4.tar.gz";
       sha256 = "121qq4al4in5pmq4am8aa2g70476yp2kvk2bb0y29cdsj2kirycl";
     };

     doCheck = false;
     buildInputs = [
		    python36Full
                    cudatoolkit
                    cudnn
                    python36Packages.requests
                    python36Packages.pyglet
                    python36Packages.six
                    python36Packages.numpy
                    python36Packages.scipy
                   ];
   };

   bintrees = buildPythonPackage rec {
     pname = "bintrees";
     version = "2.0.7";
     name = "${pname}-${version}";

    src = (import <nixpkgs> {}).fetchFromGitHub {
      owner = "mozman";
      repo = "bintrees";
      rev = "667002ae109498bad217fd0ebcdf5af7c4a34ebb";
      sha256 = "1jj6rcfyx7pp86lf7kmfy2c3gn1l2q0f1j7vaygkp7sj8shagvza";
    };

    buildInputs = [ python36Packages.attrs python36Packages.six python36Packages.pytest
                    python36Packages.testtools ];

    doCheck = false;

   };

   baselines = buildPythonPackage rec {
     pname = "baselines";
     version = "1.0.0";
     name = "${pname}-${version}";

    src = (import <nixpkgs> {}).fetchFromGitHub {
      owner = "openai";
      repo = "baselines";
      rev = "98257ef8c9bd23a24a330731ae54ed086d9ce4a7";
      sha256 = "18akgdn89gagbnds0yajlw68qmslrwrzn9s7c8wdq0airjbc6kpg";
    };

    buildInputs = [ python36Packages.attrs python36Packages.six python36Packages.pytest
                    python36Packages.testtools python36Packages.joblib python36Packages.tqdm
                    python36Packages.scipy python36Packages.dill gym 
                    ];

    doCheck = false;

   };


in

buildPythonPackage{
    name = "lanaya";
    buildInputs = [ 
                    ocl-icd
                    cudatoolkit
                    cudnn
                    python36Full
                    python36Packages.matplotlib
                    python36Packages.requests
                    python36Packages.websocket_client
                    python36Packages.tensorflowWithCuda
                    python36Packages.setuptools
                    python36Packages.pandas
                    python36Packages.numpy
                    python36Packages.pyglet
                    python36Packages.joblib
                    python36Packages.flask
                    python36Packages.cloudpickle
                    python36Packages.tqdm
                    gym
                    bintrees
                    # baselines
                   ]; 
  shellHook = ''
  # set SOURCE_DATE_EPOCH so that we can use python wheels
  SOURCE_DATE_EPOCH=$(date +%s)
  CPATH=$CPATH:~/.local/include
  LIBRARY_PATH=$LIBRARY_PATH:~/.local/lib
  LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/.local/lib
  '';

}

