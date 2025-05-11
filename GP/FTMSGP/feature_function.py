from feature_extractors import fetureDIF
from feature_extractors import hog_features_patches as hog_features
from feature_extractors import histLBP
import cv2 as cv
import numpy
from skimage.filters import _gabor
from skimage.feature import hog
import sift_features
from PIL import Image


def root_con(*args):
    feature_vector=numpy.concatenate((args),axis=None)
    return feature_vector


def all_dif(image):
    #global and local
    feature_vector = fetureDIF(image)
    # dimension 20 for all type images
    return feature_vector

def all_histogram(image):
    # global and local
    n_bins = 32
    hist, ax = numpy.histogram(image, n_bins, [0, 1])
    # dimension 24 for all type images
    return hist

def global_hog(image):
    feature_vector = hog_features(image, 20, 10)
    # dimension 144 for 128*128
    return feature_vector

def local_hog(image):
    try:
        feature_vector=hog_features(image,10,10)
    except: feature_vector = numpy.concatenate(image)
    #dimension don't know
    return feature_vector

def HoGFeatures(image):
    img,realImage=hog(image,orientations=9, pixels_per_cell=(8, 8),
                cells_per_block=(3, 3), block_norm='L2-Hys', visualise=True,
                transform_sqrt=False, feature_vector=True)
    return realImage

def local_hog_small(image):
    try:
        feature=HoGFeatures(image)
        feature_vector = numpy.concatenate(feature)
    except:
        feature_vector = numpy.concatenate(image)
    #dimension don't know
    return feature_vector

def all_lbp(image):
    # global and local
    feature_vector = histLBP(image, 1.5, 8)
    # dimension 59 for all images
    return feature_vector

def regionS(left,x,y,windowSize):
    width,height=left.shape
    x_end = min(width, x+windowSize)
    y_end = min(height, y+windowSize)
    slice = left[x:x_end, y:y_end]
    Gup1_slice=cv.pyrUp(slice)
    return Gup1_slice

def regionR(left, x, y, windowSize1,windowSize2):
    width, height = left.shape
    x_end = min(width, x + windowSize1)
    y_end = min(height, y + windowSize2)
    slice = left[x:x_end, y:y_end]
    Gup1_slice=cv.pyrUp(slice)
    return Gup1_slice


def feature_length(ind, instances, toolbox):
    func=toolbox.compile(ind)
    try:
        feature_len = len(func(instances))
    except: feature_len=0
    return feature_len,


#高斯金字塔+拉普拉斯金字塔 恢复高分辨率的不同尺寸图像
def GausDown2(left):
    G1 = cv.pyrDown(left)
    G2 = cv.pyrDown(G1)
    return G2

def GausDown1(left):
    G1 = cv.pyrDown(left)
    return G1

def GausUp1(left):
    Gup1=cv.pyrUp(left)
    return Gup1

def GausUp2(left):
    Gup1=cv.pyrUp(left)
    Gup2=cv.pyrUp(Gup1)
    return Gup2

def Laplas0(left):
    Gus1 = cv.pyrDown(left)
    Lap0 = left - cv.pyrUp(Gus1)
    return Lap0

def Resize(left,x,y):
    size = (x, y)
    shrink_AREA = cv.resize(left, size, interpolation=cv.INTER_AREA)
    # image = Image.fromarray(left)#使用Image.fromarray()函数将该数组转换回PIL图像对象
    # new_img = image.resize((x, y), Image.Resampling.LANCZOS)  # 高质量缩放图片)
    # np_array = numpy.array(new_img)#把PIL图像对象转换为numpy数组
    return shrink_AREA;


#gabor滤波可用来进行边缘检测和纹理特征提取
"通过修改frequency值来调整滤波效果，返回一对边缘结果，一个是用真实滤波核的滤波结果，一个是想象的滤波核的滤波结果。"
def gabor_filt_real(left):
    filt_real, filt_imag = _gabor.gabor(left,frequency=0.6)
    return filt_real

def gabor_filt_imag(left):
    filt_real, filt_imag = _gabor.gabor(left, frequency=0.6)
    return filt_imag

def all_sift(image):
    # global and local
    width,height=image.shape
    min_length=numpy.min((width,height))
    img=numpy.asarray(image[0:width,0:height])
    extractor = sift_features.SingleSiftExtractor(min_length)
    feaArrSingle = extractor.process_image(img[0:min_length,0:min_length])
    # dimension 128 for all images
    w,h=feaArrSingle.shape
    feature_vector=numpy.reshape(feaArrSingle, (h,))
    return feature_vector