import cv2
import numpy as np
import matplotlib.pyplot as plt

def detect_harris_corners(img, threshold=0.01):
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    gray_float = np.float32(gray)
    harris_corners = cv2.cornerHarris(gray_float, blockSize=2, ksize=3, k=0.04)
    harris_corners = cv2.dilate(harris_corners, None)
    corners = np.argwhere(harris_corners > threshold * harris_corners.max())
    keypoints = [cv2.KeyPoint(int(x[1]), int(x[0]), 1) for x in corners]
    return keypoints

def extract_sift_descriptors(img, keypoints):
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    sift = cv2.SIFT_create()
    keypoints, descriptors = sift.compute(gray, keypoints)
    return keypoints, descriptors

def match_features(desc1, desc2, num_matches=200):
    bf = cv2.BFMatcher(cv2.NORM_L2, crossCheck=True)
    matches = bf.match(desc1, desc2)
    matches = sorted(matches, key=lambda x: x.distance)
    return matches[:num_matches]

def draw_matches(img1, kp1, img2, kp2, matches):
    matched_img = cv2.drawMatches(img1, kp1, img2, kp2, matches, None, flags=cv2.DrawMatchesFlags_NOT_DRAW_SINGLE_POINTS)
    plt.imshow(cv2.cvtColor(matched_img, cv2.COLOR_BGR2RGB))
    plt.title('Harris + SIFT Feature Matching')
    plt.show()

def main(image_path_A, image_path_B, num_matches=100):
    img_A = cv2.imread(image_path_A)
    img_B = cv2.imread(image_path_B)
    keypoints_A = detect_harris_corners(img_A)
    keypoints_B = detect_harris_corners(img_B)
    keypoints_A, descriptors_A = extract_sift_descriptors(img_A, keypoints_A)
    keypoints_B, descriptors_B = extract_sift_descriptors(img_B, keypoints_B)
    matches = match_features(descriptors_A, descriptors_B, num_matches)
    draw_matches(img_A, keypoints_A, img_B, keypoints_B, matches)
    matched_points_A = np.float32([keypoints_A[m.queryIdx].pt for m in matches])
    matched_points_B = np.float32([keypoints_B[m.trainIdx].pt for m in matches])
    return matched_points_A, matched_points_B


image_path_A = 'girl5.png'
image_path_B = 'girl6.png'
(matched_points_A,matched_points_B) = main(image_path_A, image_path_B, num_matches=200)
