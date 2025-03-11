import gdown

url = 'https://drive.google.com/uc?export=download&id=1CA_1Awu-bewJKpDrILzWok_H_6cOkGDb'
output = 'uHumans2_office_s1_00h.bag'
gdown.download(url, output, quiet=False)
