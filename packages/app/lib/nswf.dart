const nsfw_labels = ['drawings', 'hentai', 'neutral', 'porn', 'sexy'];
const confidenceMap = {'hentai': 0.7, 'porn': 0.7, 'sexy': 0.7};
// const nswfRecordParams = NSFWParams(
//     useQuantizedModel: false,
//     inputBatchSize: 1,
//     inputWidth: 224,
//     inputHeight: 224,
//     inputChannels: 3,
//     labels: nsfw_labels,
//     confidenceMap: {'hentai': 0.7, 'porn': 0.7, 'sexy': 0.7},
//     //localModelAssetPath: 'assets/models/nsfw/models.tflite',
//     // labelText: "assets/models/nsfw/labels.txt",
//     resultsToShow: 3,
//     numDetectionsToReport: 5,
//     numDetectionsToWarn: 3);
// const nswfLiveParams = NSFWParams(
//     useQuantizedModel: false,
//     inputBatchSize: 1,
//     inputWidth: 224,
//     inputHeight: 224,
//     inputChannels: 3,
//     labels: nsfw_labels,
//     confidenceMap: {'porn': 0.89},
//     //localModelAssetPath: 'assets/models/nsfw/models.tflite',
//     // labelText: "assets/models/nsfw/labels.txt",
//     resultsToShow: 3,
//     numDetectionsToReport: 5,
//     numDetectionsToWarn: 3);