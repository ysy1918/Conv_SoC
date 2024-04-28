file = 'C:\Users\13069\Desktop\class_file\Master\SoC\CNN_accelerator\Conv_SoC\auxi\data.txt';
%image = zeros(9,8,3);
%image(1:8,:,:) = randi([-3, 3], 8, 8, 3);
%image(1:8,:,:) = ones(8, 8, 3);
%filter = randi([-1, 1], 2, 2, 3);
%filter = ones(2, 2, 3);
image_t = pagetranspose(image);
serial_image = zeros(256,1);
for i=1:8
    serial_image(1+15*(i-1):15*i) =  reshape(image(1:5,i,:),[15,1]);
    serial_image(121+15*(i-1):120+15*i) =  reshape(image(5:9,i,:),[15,1]);
end
serial_image(241:252) = reshape(filter,[12,1]);

bin_serial_image = dec2bin(int8(serial_image));

fileID = fopen('data.bin', 'w');

[m,n]=size(bin_serial_image);
for i=1:1:m
    for j=1:1:n
       if j==n
         fprintf(fileID,'%c\n',bin_serial_image(i,j));
      else
        fprintf(fileID,'%c',bin_serial_image(i,j));
       end
    end
end
fclose(fileID);
output1 = conv2(image(1:8,:,1), flipud(fliplr(filter(:,:,1))));
output2 = conv2(image(1:8,:,2), flipud(fliplr(filter(:,:,2))));
output3 = conv2(image(1:8,:,3), flipud(fliplr(filter(:,:,3))));

output = output1 + output2 + output3;
