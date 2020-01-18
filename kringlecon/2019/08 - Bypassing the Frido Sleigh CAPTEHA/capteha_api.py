#!/usr/bin/env python3
# Fridosleigh.com CAPTEHA API - Made by Krampus Hollyfeld

# this is a modified version of the demo given by Chris Davis
# we load from base64 instead of memory & don't cap threads as we're doing GPU processing.
# Also to get it to work in time I had to use the mobilenet 224 quantized version (ns if quantized version needed, could probaby do normal version since we didn't use TensorFlow Lite)
# model was trained as follow:
# python37 ./retrain.py --image_dir '.\training_images\' \
#  --learning_rate=0.0001 --testing_percentage=20 --validation_percentage=20 \
#  --train_batch_size=32 --validation_batch_size=-1 --flip_left_right True \
#  --random_scale=20 --random_brightness=20 --eval_step_interval=100 \
#  --how_many_training_steps=1400 --tfhub_module https://tfhub.dev/google/imagenet/mobilenet_v1_100_224/quantops/feature_vector/3

import requests
import json
import sys

import pybase64

import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
import tensorflow as tf
tf.logging.set_verbosity(tf.logging.ERROR)
import numpy as np
import threading
import queue
import time
import sys

def load_labels(label_file):
    label = []
    proto_as_ascii_lines = tf.gfile.GFile(label_file).readlines()
    for l in proto_as_ascii_lines:
        label.append(l.rstrip())
    return label

def predict_image(q, sess, graph, image_bytes, img_uuid, labels, input_operation, output_operation):
    image = read_tensor_from_image_bytes(image_bytes)
    results = sess.run(output_operation.outputs[0], {
        input_operation.outputs[0]: image
    })
    results = np.squeeze(results)
    prediction = results.argsort()[-5:][::-1][0]
    q.put( {'uuid':img_uuid, 'prediction':labels[prediction].title(), 'percent':results[prediction]} )

def load_graph(model_file):
    graph = tf.Graph()
    graph_def = tf.GraphDef()
    with open(model_file, "rb") as f:
        graph_def.ParseFromString(f.read())
    with graph.as_default():
        tf.import_graph_def(graph_def)
    return graph

def read_tensor_from_image_bytes(imagebytes, input_height=224, input_width=224, input_mean=0, input_std=255):
    image_reader = tf.image.decode_png( imagebytes, channels=3, name="png_reader")
    float_caster = tf.cast(image_reader, tf.float32)
    dims_expander = tf.expand_dims(float_caster, 0)
    resized = tf.image.resize_bilinear(dims_expander, [input_height, input_width])
    normalized = tf.divide(tf.subtract(resized, [input_mean]), [input_std])
    sess = tf.compat.v1.Session()
    result = sess.run(normalized)
    return result

def prepare_tensorflow():
    global graph, labels, input_operation, output_operation
    # Loading the Trained Machine Learning Model created from running retrain.py on the training_images directory
    graph = load_graph('/tmp/retrain_tmp/output_graph.pb')
    labels = load_labels("/tmp/retrain_tmp/output_labels.txt")

    # Load up our session
    input_operation = graph.get_operation_by_name("import/Placeholder")
    output_operation = graph.get_operation_by_name("import/final_result")
    sess = tf.compat.v1.Session(graph=graph)
    return sess

def process_base64(sess, b64_images, find_types):

    q = queue.Queue()

    #Going to interate over each of our images.
    for image_pair in b64_images:
        
        #print('Processing Image {}'.format(image_pair["uuid"]))

        #predict_image function is expecting png image bytes so we read image as 'rb' to get a bytes object
        image_bytes = pybase64.b64decode(image_pair["base64"], validate=True)
        threading.Thread(target=predict_image, args=(q, sess, graph, image_bytes, image_pair["uuid"], labels, input_operation, output_operation)).start()
    
    print('Waiting For Threads to Finish...')
    while q.qsize() < len(b64_images):
        time.sleep(0.1)
    
    #getting a list of all threads returned results
    prediction_results = [q.get() for x in range(q.qsize())]

    print("types: ", find_types)

    found = ""
    
    #do something with our results... Like print them to the screen.
    for prediction in prediction_results:
        if prediction["prediction"] in find_types:
            found += prediction["uuid"] + ","
            print('TensorFlow Predicted {uuid} is a {prediction} with {percent:.2%} Accuracy'.format(**prediction))
    return found

def main():
    if len(sys.argv) < 2:
        print("Uh oh, forgot to pass email in!")
        return
    sess = prepare_tensorflow()

    yourREALemailAddress = sys.argv[1]

    # Creating a session to handle cookies
    s = requests.Session()
    url = "https://fridosleigh.com/"

    print("getting server...")

    json_resp = json.loads(s.get("{}api/capteha/request".format(url)).text)
    b64_images = json_resp['images']                    # A list of dictionaries eaching containing the keys 'base64' and 'uuid'
    challenge_image_type = json_resp['select_type'].split(',')     # The Image types the CAPTEHA Challenge is looking for.
    challenge_image_types = [challenge_image_type[0].strip(), challenge_image_type[1].strip(), challenge_image_type[2].replace(' and ','').strip()] # cleaning and formatting

    print("got images...nn time")
    
    found = process_base64(sess, b64_images, challenge_image_types)
    found = found[:-1] # ah man this bug was terrible, we need to strip that last comma from the string otherwise it counts as an empty entry :D
    
    # This should be JUST a csv list image uuids ML predicted to match the challenge_image_type .
    # final_answer = ','.join( [ img['uuid'] for img in b64_images ] )
    print("solved images, posting...")

    json_resp = json.loads(s.post("{}api/capteha/submit".format(url), data={'answer':found}).text)
    if not json_resp['request']:
        # If it fails just run again. ML might get one wrong occasionally
        print('FAILED MACHINE LEARNING GUESS')
        print('--------------------\nOur ML Guess:\n--------------------\n{}'.format(found))
        print('--------------------\nServer Response:\n--------------------\n{}'.format(json_resp['data']))
        array = found.split(',')
        for image_pair in b64_images:
            if image_pair["uuid"] in array:
                newfile = open(image_pair["uuid"] + ".png", "wb")
                newfile.write(pybase64.b64decode(image_pair["base64"], validate=True))

        sys.exit(1)

    print('CAPTEHA Solved!')
    # If we get to here, we are successful and can submit a bunch of entries till we win
    userinfo = {
        'name':'Krampus Hollyfeld',
        'email':yourREALemailAddress,
        'age':180,
        'about':"Cause they're so flippin yummy!",
        'favorites':'thickmints'
    }
    # If we win the once-per minute drawing, it will tell us we were emailed. 
    # Should be no more than 200 times before we win. If more, somethings wrong.
    entry_response = ''
    entry_count = 1
    while yourREALemailAddress not in entry_response and entry_count < 200:
        print('Submitting lots of entries until we win the contest! Entry #{}'.format(entry_count))
        entry_response = s.post("{}api/entry".format(url), data=userinfo).text
        entry_count += 1
    print(entry_response)


if __name__ == "__main__":
    main()