import torch
import numpy as np
import torch.nn as nn
import time
import torch.utils.data as Data
import torch.nn.functional as F
from scBalance.scBalance_classifier import classifier
from scBalance.weightsampling import Weighted_Sampling

def scBalance(test = None, reference = None, label = None, processing_unit = 'cpu'):

    '''

    :param test: Input your test dataset to annotate
    :param reference: Input your reference dataset
    :param label: Input label set
    :param processing_unit: Choose which processing unit you would like to use,
    if you choose 'gpu', than the software will try to access CUDA,
    if you choose 'cpu', the software will use CPU as default.
    :return:
    '''

    label.columns = ['Label']
    label.Label.value_counts()
    status_dict = label['Label'].unique().tolist()
    int_label = label['Label'].apply(lambda x: status_dict.index(x))
    label.insert(1,'transformed',int_label)

    X_train = reference.values
    X_test = test.values
    y_train = label['transformed'].values

    dtype = torch.float
    X_train = torch.from_numpy(X_train)
    X_test = torch.from_numpy(X_test)
    y_train = torch.from_numpy(y_train)

    sampler = Weighted_Sampling(y_train)

    #construct pytorch object
    train_data = Data.TensorDataset(X_train, y_train)
    train_loader = Data.DataLoader(dataset=train_data,
                                   batch_size=128,
                                   sampler = sampler,
                                   num_workers=1)

    input_size = X_train.shape[1]
    num_class = len(status_dict)
    num_epochs = 20

    model = classifier(input_size, num_class)

    criterion = nn.CrossEntropyLoss()
    optimizer = torch.optim.Adam(model.parameters(), lr=0.005)
    total_step = len(train_loader)

    print("--------Start annotating----------")
    start = time.perf_counter()

    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    if processing_unit == 'cpu':
        device = torch.device('cpu')
    elif processing_unit == 'gpu':
        if torch.cuda.is_available():
            device = torch.device('cuda')
        else:
            device = torch.device('cpu')
            print("No GPUs are available on your server.")

    print("Computational unit be used is:", device)

    model.to(device)

    model.train()
    for epoch in range(num_epochs):
        for step, (batch_x, batch_y) in enumerate(train_loader):
            batch_x, batch_y = batch_x.to(device), batch_y.to(device)
            outputs = model(batch_x)
            train_loss = criterion(outputs, batch_y)

            # Backward and optimize
            optimizer.zero_grad()
            train_loss.backward()
            optimizer.step()

        a = "=" * (epoch + 1)
        b = "." * (num_epochs - epoch - 1)
        c = ((epoch + 1) / num_epochs) * 100
        dur = time.perf_counter() - start
        print("\r{:^3.0f}%[{}->{}]{:.2f}s".format(c, a, b, dur), end='')
        time.sleep(0.1)

    print("\n--------Annotation Finished----------")

    model.eval()
    with torch.no_grad():
        X_test = X_test.to(device)
        output = model(X_test)

    temp = F.softmax(output, dim=1)
    pred = torch.argmax(temp, dim=1).cpu()

    result = list(pred.numpy())
    results = []
    for i in result:
        results.append(status_dict[i])

    return results