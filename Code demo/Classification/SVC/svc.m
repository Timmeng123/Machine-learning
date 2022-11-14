[heart_scale_label,heart_scale_inst]=libsvmread('heart_scale');
model = svmtrain(heart_scale_label,heart_scale_inst) ;
[predict_label,accuracy,dec_values] = svmpredict(heart_scale_label,heart_scale_inst,model);
