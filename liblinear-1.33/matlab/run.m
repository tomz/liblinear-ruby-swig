[y,xt] = read_sparse('../heart_scale');
model=train(y, xt)
[l,a]=predict(y, xt, model);

