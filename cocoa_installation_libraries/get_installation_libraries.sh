#!/bin/bash

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

echo '\033[1;34m''\t GET_INSTALLATION_LIBRARIES''\033[0m'

if [ -z "${ROOTDIR}" ]; then
    echo '\033[0;31m''ERROR ENV VARIABLE ROOTDIR IS NOT DEFINED''\033[0m'
    return 1
fi

if [ -z "${DEBUG_GET_INSTALLATION_LIBRARIES_OUTPUT}" ]; then
  export OUTPUT_GIL_1="/dev/null"
  export OUTPUT_GIL_2="/dev/null"
else
  export OUTPUT_GIL_1="/dev/tty"
  export OUTPUT_GIL_2="/dev/tty"
fi


# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

if [ -z "${IGNORE_CMAKE_INSTALLATION}" ]; then
    echo '\033[0;32m'"\t\tGETTING CMAKE LIBRARY"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}

    cd $ROOTDIR/../cocoa_installation_libraries/
    
    git clone https://github.com/Kitware/CMake.git cmake-3.26.4
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"CMAKE: COULD NOT RUN \e[3mGIT CLONE"'\033[0m'
        cd $ROOTDIR
        return 1
    fi
    
    cd $ROOTDIR/../cocoa_installation_libraries/cmake-3.26.4
    
    git checkout v3.26.4
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"CMAKE: COULD NOT RUN \e[3mGIT CHECKOUT"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    rm -rf $ROOTDIR/../cocoa_installation_libraries/cmake-3.26.4/.git/
  
    cd $ROOTDIR/../cocoa_installation_libraries/
    
    tar -cf - cmake-3.26.4/ | xz -k -1 --threads=$MAKE_NUM_THREADS -c - > cmake.xz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"CMAKE: COULD NOT COMPRESS \e[3mCMAKE FOLDER"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    echo '\033[0;32m'"\t\tGETTING CMAKE LIBRARY DONE"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
fi

# --------------------------------------------------------------------------------
# --------------------------------------------------------------------------------
# --------------------------------------------------------------------------------

if [ -z "${IGNORE_DISTUTILS_INSTALLATION}" ]; then
    echo '\033[0;32m'"\t\tGETTING BINUTILS LIBRARY"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}

    cd $ROOTDIR/../cocoa_installation_libraries/

    wget -q https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.gz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"BINUTILS: COULD NOT RUN \e[3mWGET"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    tar zxvf binutils-2.37.tar.gz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"BINUTILS: COULD NOT RUN \e[3mTAR (UNCOMPRESS)"'\033[0m'
        cd $ROOTDIR
        return 1
    fi
    rm -f $ROOTDIR/../cocoa_installation_libraries/binutils-2.37.tar.gz

    
    tar -cf - binutils-2.37/ | xz -k -1 --threads=$MAKE_NUM_THREADS -c - > binutils.xz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"BINUTILS: COULD NOT COMPRESS \e[3mBINUTILS FOLDER"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    echo '\033[0;32m'"\t\tGETTING BINUTILS LIBRARY DONE"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
fi

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

if [ -z "${IGNORE_DISTUTILS_INSTALLATION}" ]; then
    echo '\033[0;32m'"\t\tGETTING TEXINFO LIBRARY"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}

    cd $ROOTDIR/../cocoa_installation_libraries/

    wget -q https://ftp.gnu.org/gnu/texinfo/texinfo-7.0.3.tar.xz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"TEXINFO: COULD NOT RUN \e[3mWGET"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    tar xf texinfo-7.0.3.tar.xz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"TEXINFO: COULD NOT RUN \e[3mTAR (UNCOMPRESS)"'\033[0m'
        cd $ROOTDIR
        return 1
    fi
    rm -f $ROOTDIR/../cocoa_installation_libraries/texinfo-7.0.3.tar.xz


    tar -cf - texinfo-7.0.3/ | xz -k -1 --threads=$MAKE_NUM_THREADS -c - > texinfo.xz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"TEXINFO: COULD NOT COMPRESS \e[3mTEXINFO FOLDER"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    echo '\033[0;32m'"\t\tGETTING TEXINFO LIBRARY DONE"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
fi

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

if [ -z "${IGNORE_OPENBLAS_INSTALLATION}" ]; then
    echo '\033[0;32m'"\t\tGETTING OPENBLAS LIBRARY"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
    
    cd $ROOTDIR/../cocoa_installation_libraries/

    git clone https://github.com/OpenMathLib/OpenBLAS.git OpenBLAS-0.3.23
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"OPENBLAS: COULD NOT RUN \e[3mGIT CLONE"'\033[0m'
        cd $ROOTDIR
        
    fi

    cd $ROOTDIR/../cocoa_installation_libraries/OpenBLAS-0.3.23

    git checkout v0.3.23
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"OPENBLAS: COULD NOT RUN \e[3mGIT CHECKOUT"'\033[0m'
        cd $ROOTDIR
        
    fi

    rm -rf $ROOTDIR/../cocoa_installation_libraries/OpenBLAS-0.3.23/.git/

    tar -cf - OpenBLAS-0.3.23/ | xz -k -1 --threads=$MAKE_NUM_THREADS -c - > OpenBLAS.xz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"OPENBLAS: COULD NOT COMPRESS \e[3mOPENBLAS FOLDER"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    echo '\033[0;32m'"\t\tGETTING OPENBLAS LIBRARY DONE"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
fi

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

if [ -z "${IGNORE_FORTRAN_LAPACK_INSTALLATION}" ]; then
    echo '\033[0;32m'"\t\tGETTING LAPACK LIBRARY"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
    
    cd $ROOTDIR/../cocoa_installation_libraries/

    git clone https://github.com/Reference-LAPACK/lapack.git lapack
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"LAPACK: COULD NOT RUN \e[3mGIT CLONE"'\033[0m'
        cd $ROOTDIR
        
    fi

    cd $ROOTDIR/../cocoa_installation_libraries/lapack-3.11.0
    
    git checkout lapack-3.11.0
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"LAPACK: COULD NOT RUN \e[3mGIT CHECKOUT"'\033[0m'
        cd $ROOTDIR
        
    fi

    rm -rf $ROOTDIR/../cocoa_installation_libraries/lapack-3.11.0/.git/

    cd $ROOTDIR/../cocoa_installation_libraries/

    tar -cf - lapack-3.11.0/ | xz -k -1 --threads=$MAKE_NUM_THREADS -c - > lapack.xz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"LAPACK: COULD NOT COMPRESS \e[3mLAPACK FOLDER"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    echo '\033[0;32m'"\t\tGETTING LAPACK LIBRARY DONE"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
fi

# --------------------------------------------------------------------------------
# --------------------------------------------------------------------------------
# --------------------------------------------------------------------------------
if [ -z "${IGNORE_HDF5_INSTALLATION}" ]; then
    echo '\033[0;32m'"\t\tGETTING HDF5 LIBRARY"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}

    cd $ROOTDIR/../cocoa_installation_libraries/

    wget -q https://hdf-wordpress-1.s3.amazonaws.com/wp-content/uploads/manual/HDF5/HDF5_1_12_3/src/hdf5-1.12.3.tar.gz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"HDF5: COULD NOT RUN \e[3mWGET"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    tar zxvf hdf5-1.12.3.tar.gz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"HDF5: COULD NOT RUN \e[3mTAR (UNCOMPRESS)"'\033[0m'
        cd $ROOTDIR
        return 1
    fi
    rm -f $ROOTDIR/../cocoa_installation_libraries/hdf5-1.12.3.tar.gz

    tar -cf - hdf5-1.12.3/ | xz -k -1 --threads=$MAKE_NUM_THREADS -c - > hdf5.xz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"HDF5: COULD NOT COMPRESS \e[3mHDF5 FOLDER"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    echo '\033[0;32m'"\t\tGETTING HDF5 LIBRARY DONE"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
fi

# --------------------------------------------------------------------------------
# --------------------------------------------------------------------------------
# --------------------------------------------------------------------------------

if [ -z "${IGNORE_C_CFITSIO_INSTALLATION}" ]; then
    echo '\033[0;32m'"\t\tGETTING CFITSIO LIBRARY"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}

    cd $ROOTDIR/../cocoa_installation_libraries/

    wget -q http://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.0.0.tar.gz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"CFITSIO: COULD NOT RUN \e[3mWGET"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    tar zxvf cfitsio-4.0.0.tar.gz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"CFITSIO: COULD NOT RUN \e[3mTAR (UNCOMPRESS)"'\033[0m'
        cd $ROOTDIR
        return 1
    fi
    rm -f $ROOTDIR/../cocoa_installation_libraries/cfitsio-4.0.0.tar.gz

    tar -cf - cfitsio-4.0.0/ | xz -k -1 --threads=$MAKE_NUM_THREADS -c - > cfitsio.xz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"CFITSIO: COULD NOT COMPRESS \e[3mCFITSIO FOLDER"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    echo '\033[0;32m'"\t\tGETTING CFITSIO LIBRARY DONE"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
fi

if [ -z "${IGNORE_C_FFTW_INSTALLATION}" ]; then
    echo '\033[0;32m'"\t\tGETTING FFTW LIBRARY"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
    
    wget -q http://www.fftw.org/fftw-3.3.10.tar.gz 
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"FFTW: COULD NOT RUN \e[3mWGET"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    tar zxvf fftw-3.3.10.tar.gz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"FFTW: COULD NOT RUN \e[3mTAR (UNCOMPRESS)"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    rm -f fftw-3.3.10.tar.gz

    tar -cf - fftw-3.3.10/ | xz -k -1 --threads=$MAKE_NUM_THREADS -c - > fftw.xz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"FFTW: COULD NOT COMPRESS \e[3mFFTW FOLDER"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    echo '\033[0;32m'"\t\tGETTING FFTW LIBRARY DONE"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
fi

if [ -z "${IGNORE_C_GSL_INSTALLATION}" ]; then
    echo '\033[0;32m'"\t\tGETTING GSL LIBRARY"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}

    cd $ROOTDIR/../cocoa_installation_libraries/

    wget -q http://ftp.wayne.edu/gnu/gsl/gsl-2.7.tar.gz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"GSL: COULD NOT RUN \e[3mWGET"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    tar zxvf gsl-2.7.tar.gz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"GSL: COULD NOT RUN \e[3mTAR (UNCOMPRESS)"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    rm -f ROOTDIR/../cocoa_installation_libraries/gsl-2.7.tar.gz

    tar -cf - gsl-2.7/ | xz -k -1 --threads=$MAKE_NUM_THREADS -c - > gsl.xz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"GSL: COULD NOT COMPRESS \e[3mGSL FOLDER"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    echo '\033[0;32m'"\t\tGETTING GSL LIBRARY DONE"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
fi

# --------------------------------------------------------------------------------
# --------------------------------------------------------------------------------
# --------------------------------------------------------------------------------

if [ -z "${IGNORE_CPP_SPDLOG_INSTALLATION}" ]; then
    echo '\033[0;32m'"\t\tGETTING SPDLOG LIBRARY"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
    
    cd $ROOTDIR/../cocoa_installation_libraries/

    git clone https://github.com/gabime/spdlog.git spdlog
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"SPDLOG: COULD NOT RUN \e[3mGIT CLONE"'\033[0m'
        cd $ROOTDIR
        
    fi

    cd $ROOTDIR/../cocoa_installation_libraries/spdlog

    git checkout v1.13.0
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"SPDLOG: COULD NOT RUN \e[3mGIT CHECKOUT"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    rm -rf $ROOTDIR/../cocoa_installation_libraries/spdlog/.git/

    tar -cf - spdlog/ | xz -k -1 --threads=$MAKE_NUM_THREADS -c - > spdlog.xz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"SPDLOG: COULD NOT COMPRESS \e[3mSPDLOG FOLDER"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    echo '\033[0;32m'"\t\tGETTING SPDLOG LIBRARY DOONE"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
fi

if [ -z "${IGNORE_CPP_ARMA_INSTALLATION}" ]; then
    echo '\033[0;32m'"\t\tGETTING ARMA LIBRARY"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
    
    cd $ROOTDIR/../cocoa_installation_libraries/

    wget -q https://sourceforge.net/projects/arma/files/armadillo-12.8.2.tar.xz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"ARMA: COULD NOT RUN \e[3mWGET"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    tar xf armadillo-12.8.2.tar.xz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"ARMA: COULD NOT RUN \e[3mTAR (UNCOMPRESS)"'\033[0m'
        cd $ROOTDIR
        return 1
    fi
    
    rm -f ROOTDIR/../cocoa_installation_libraries/armadillo-12.8.2.tar.xz

    tar -cf - armadillo-12.8.2/ | xz -k -1 --threads=$MAKE_NUM_THREADS -c - > armadillo.xz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"ARMA: COULD NOT COMPRESS \e[3mARMA FOLDER"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    echo '\033[0;32m'"\t\tGETTING ARMA LIBRARY DONE"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
fi

if [ -z "${IGNORE_CPP_BOOST_INSTALLATION}" ]; then
    echo '\033[0;32m'"\t\tGETTING BOOST LIBRARY"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
    
    cd $ROOTDIR/../cocoa_installation_libraries/

    wget -q https://boostorg.jfrog.io/artifactory/main/release/1.81.0/source/boost_1_81_0.tar.gz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"BOOST: COULD NOT RUN \e[3mWGET"'\033[0m'
        cd $ROOTDIR
        
    fi
    
    tar xvzf boost_1_81_0.tar.gz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"BOOST: COULD NOT RUN \e[3mTAR (UNCOMPRESS)"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    rm -f ROOTDIR/../cocoa_installation_libraries/boost_1_81_0.tar.gz
    
    tar -cf - boost_1_81_0/ | xz -k -1 --threads=$MAKE_NUM_THREADS -c - > boost.xz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"BOOST: COULD NOT COMPRESS \e[3mBOOST FOLDER"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    echo '\033[0;32m'"\t\tGETTING BOOST LIBRARY DONE"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
fi

if [ -z "${IGNORE_CPP_CARMA_INSTALLATION}" ]; then
    echo '\033[0;32m'"\t\tGETTING CARMA LIBRARY"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
    
    cd $ROOTDIR/../cocoa_installation_libraries/

    git clone https://github.com/RUrlus/carma.git carma_tmp
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"CARMA: COULD NOT RUN \e[3mGIT CLONE"'\033[0m'
        cd $ROOTDIR
        
    fi

    cd $ROOTDIR/../cocoa_installation_libraries/carma_tmp

    git checkout v0.7.0
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"CARMA: COULD NOT RUN \e[3mGIT CHECKOUT"'\033[0m'
        cd $ROOTDIR
        return 1
    fi

    mv ./include ../

    cd $ROOTDIR/../cocoa_installation_libraries/

    mv ./include carma

    rm -rf $ROOTDIR/../cocoa_installation_libraries/carma_tmp

    tar -cf - carma/ | xz -k -1 --threads=$MAKE_NUM_THREADS -c - > carma.xz
    if [ $? -neq 0 ];then
        echo '\033[0;31m'"CARMA: COULD NOT COMPRESS \e[3mCARMA FOLDER"'\033[0m'
        cd $ROOTDIR
        return 1
    fi  

    echo '\033[0;32m'"\t\tGETTING CARMA LIBRARY DONE"'\033[0m' > ${OUTPUT_GIL_1} 2> ${OUTPUT_GIL_2}
fi

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

echo '\033[1;34m''\t \e[4mGET_INSTALLATION_LIBRARIES''\033[0m'

