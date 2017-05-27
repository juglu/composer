(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� g)Y �]Y��ʶ���
��o��q�IQAAD�ƍ
f'AE���������*v�h��n43I�\��[+{e��d_��2���__� M��+J�����Bq�0
#i�/�1��F~Msc����V�k���i�r�����p�?������rz���x�}ʈ�\�MR����[�MAe \,!��x���>�.�?JRH%�2p�����+���p��	�������?���:N�7���*���k���N�;�����q0Ew�~z-�=�h, (J҅�����<��8^�V��)>g���b�"��y8eS.a�4M�4�:$a��"�#��>M��ڎG�.�">��d_5�*��2������I�����#]Ԑ2:���WGpbCVk"/�A���&0�Z[�Ny��ty���,#�.��&���[�j��Z��P6m-hS���Zv�)�� n����W�،���@O+16)=�;�|<7�}��QQ��:�=��񔥇��VB�F��� �f�OX�z_^Ⱥ,R�B�#[��������Щ��*���tG�����o{�t����u���FW�����qu�z��уg���QǞ���)x��yQ7dI��y��e�o<�nr���)K�Of}o�9�5��E����p5�Ϻ=M��-�!^�S�b�2�P�t ���0)�����e�C��Ny�NQ����������3� �
`�7O�m�w���q'�ǅ������b<j����)1�C�Aɕ��`!��C.��z�O�-A�(`~n�D�MSى�C�C�����������N���9�5�țr7�6�8Xs�*���f�b.�~�|������[K���
�4���6A(�(:})( 2�T_#Bi���Ю/滑D���H���`��Ɗ�Q+S��_vЦ�6��0�Y�%C��#�w��f��9�[ݙ��\����� �������k�Q���N}��=/�����V�x.,)@�@�����u���(��EƤ����7+&@fK��(�t isy�1����R��(y��@����u��@.|[$�%���1�e�����}v�7��k�r�-'iKj����Ũ��,��Ez ǢϙE/�f�\�}X|`6<����,����i�����P��$�?Jj����S��P
��������'����G�y��S��]��H��9Zr;ˇr$��B?c�K����P�I9�S�bqU0U��"��~�Wf�}�"�;� Z�XX���+9$�MY���q��h1Qt+��)�)�a�P_�&N�&.�n��s���2�M���4���j�vZ�b�w� 4��[�.u��z��3w�V�J�Bx��К0
�-�G�H�-MSΌ�5 �$./�@���y����*�q���1�����8�t�܇�.��w|K3ymJ
�(�Hs?4���\rآQ��R�l�9��L�k|'p$�,���&��/�D�0����t��<�1>�@��亖L��)�fV}ȡ�a��?�����k���?��$IU���S������G��F����@��W�������/��w�^��D�V�_~I�_�S�������~}��>E8�b�P6[\� �H���0M���H@�.���Ca��(����U�?�ʐ�����(����2pA�����IA+G�	�2�x���
� 4.�7�|x1�g-[�m[����r�45~��Ko�R��d3D��/9��g�A�ۑ���s���W����v+�j� �n���iX��|�4��2����/�%�O��!*�_���j��Z����>���2����R�I����?��W��3����̡�H�>BaJo�vZ�¿���O���|��,a��Y�c�gb>4����m��܏T8.Wy �Ȥ���L꽩4��s�m��{�;�9TD:FwE�z�ӹ��6֛ɼa�]c~��@�t��ʝ��1v���k̑��#�r68F$�{�����[�i��1K �L�0$�@ ��6PĖ �!/X��k�N8a7E�j�de:�� �n��;���GӞ=4�*���TQ��w{�χf=�/��$d�����f�u��LiYZw4�C^nvL5QBډI�H�,E�vC2�	\��d�Ѓ������%����?d��e�S���?H������+�����\{���ߵ?|����&@��e���A�/�b�?�U�_
*������?����?�zl h��T�e����t���GC�'��]����p�����Q�a	�DX�qX$@H�Ei�$)�����P��/��Ch
��2pA��ʄ]�_�V�byñ9�5�f{�9Ҫ�l�m��Rx1�%���q�N+)54$wm'���ǫ{���(ǌ��v��7pD���������=n2�L?�SJN�v�*���x<�����O?�b���j���C�??x
������rp��o?_�.�?N"��/����ۏ/+���OㅻXɿ|��_�z��qC�����wX��p���O�Z�)_2�Y���ň��ǶI��)�B]�B<�`Y�����w]7��%� p|�eX��JC�|�G��?U�?_������Aj�h�(��P�A����0�.���]#M���/���4���v]wW����s)���aDn5f����Q�5#���n��������j=qMP��	ff�^��|�9�_�����+����JO�?
�+��|���}i�P�2Q��߰�P�|�M6ae��������/��q�s�@��8�Z���� sߐ���<�}��ϒ ���?c�~�0�?���\�[7�nd���}t�zt4tw�Gρ�4���i疉��O}vJ��y�Jw�m�=b���t�o�0��"F�E7Ӭ����	5��D�Xo�Ql�f:Gm᭸h.)�74L��(g=�@�p[�G1��#�Gz�I��9|��I,̹����p�wk�ʹ�Q�hMX���UjS����ҝJ���9�[a��5� �RgD��ކ��t�w��n7�5���`��Ԝ��]]q��B[��n;i�圳�xJX9[��1�C�y��L;AO�%�����ӻ�����E�/��4����>S�����?NT�)�-�
���_3��[��%ʐ�������JW翗������������k���;��4r�����>}�ǽ��O��|�o �my�>��} �Gܖ�^��}�4��r���=8"1��C�MIiK[TwDck6�^�͵F߲���m{���L�ص4�aH���dNS�28�PеDr��8�I�� ��B��<���]j�?6�Y�|�9���f-x6���nڷW�`�5��\��^J�r��{���,�C��z}��{���46a�Dw�h�"����������_:�r��(^�������'��T�J�W��j��߃2�������V��ףZ�������j�����C��\l�cV��s9�\��[w�?F!t�Y
*������?�����z��S��[)���	��i�P��"Y�eh��(�	�	� �]�}�pȀ�� �}�r]�q�N���P��߰�~v��)�������J˔l99�[�Ԍa��"4����V�X�<�-j���c�鸭��+�{ɚ�zb��vp�*�(�9����Q���w-���3�(C�Sez��RGYl�C�j��G����O��%q�_���?��������Ū��*[?�
-���7�7e~���~���\9^j�id����d������b:��N�+���c���B��k��^$�t���N�x�����Z��&N���4�����.��Z�����ӍI���u��FH�����Ҋ��K�[-�Ԯ���O�Ż�])��Պ`��ko>��yh?:����e�|��y�+�v�`���o��]��N]�����G��%��}{�[���rmO�~z���bT���]ePQ��V�9O��1�n�]4��� �~�UQ����7D�.��ߑ�ӟK�}���F�+|?��������>w�z��8N����U��E�g_nl��ߓ����ŗ7K���Q��l/V`t�7E�p�xW{����ǒ�LZ�����q��q��Z�������۫��ݮ�����{�*�~����{,��-��JcK����y�Χ��ƛ��jp���0N���R���ƹ.T�O��#��k���O4a���"D~��j��Ծ���}��?��Y<���?W��7tñ�E��������w�F���Y��;{�@�Uő�}�n��ɦR��וU��f9�}�axgkxk�p�Y�gK�:{8�Ow��b������u���p�\υˡ��2f��{�t]�ҡ"]�n;]�ukO׵ۺ���;1AM�	&����?1�OJ�F��|P	4bD!&������l;g�p� ���=]�^����=���{�G7��ۛ���Lg̃�M�Wn�͠��LCĮ�~�H&�X$�g����h� k$���R���H<��ֶ�P=I]���}N'��u�fZL�2:]Z�����ټ�yxfs��s@	��0.�Î��;��$�=�n��Dsp�n�\�wBs�-3���U�n z-��6`��j���G���n+����6j��U� ����3���s�J�~��d&;�!���d��u��ĸ�R������n猛p��>��kƙ����҈y$DfUJ��g�e�hY�}�F����[(-�KCƬ��+|��]�=t��,/j���r4E>�h�C޷h�Ц�9
�.�dé�G�S��b�p�~Gp:91�Ӏٝ�#Z����� vr��"�A�;�ʢ޾sa�����1�I�Vc�2Ǻj��/dtI:�4`q���9�:�!���p�w��9��S�l�k��f$tQ������7��]������
C0��e�����C�|��.8.���_�a*�Jc�1CJ��&o=�^��]�E.��-j�"Ƀ[kgk��.לP�Օ��М���H���=����L��*�T����
��w�y>��܃sэ\�f����ǜ�n��!3�%8��t�v1A3�6'f�aoZ�w:��Υ�S����0W����ꪽ$���u�v!Gk��]{�#Xvu����W��j:��>��Ѽqѹ�B�{��'�daý���U���ܨ�������������'�J<
k'6N�=���~~��ZK%.<��T�~��U z
������ߏ��m/ˣ����U�.}T�|����á����Cp��ޡ���_���/��z��j�'�M��~�ң��
���n�OP�Ϝ��q ��z�N v��Ћwn����8|���s��f����� glj�oj��/n
sF�>����,n���^T�t����X��6z	c�yN�=W���D��� C�w~�����2]�a���f��#��!xv�e��l�(�ϐn7�/D�����
m�Y@�����50_����N��4�/�(������}N6s��x� �8���dC�`)Ly����~��0�DW�h5����tp�#\�ǔ� �O�ɂ}v{k�P&���Lc3U\dB*�=�z6ߣ�x���
�SՖ���KAI�VIUe�e�!>��RjJ��^o���,��#�AO����6�f®��>a�C�R�"lxjSOa�M=�!�5;��f{��Ss%dݪ�8���Z4]S�7������@&)m���v���e����_�D� �˓����=������b&Lf�p>!� a��!+�;LI�S0ӂ� jG2,���	xY��Ȏ��!+މl�� ���x�UR�e�����b9!�)_��b5͋��8P2���*�F���\5�L��v"^ ��0����1&��6�ﾲ��IY�l�:�,[��f�; �\��v8���p�w'�f�C�W{Z�3\+�;�p�EZ�J(Ɗ��ؤ��8%��J��reeP�m�pʂ3�׊�ÅTP4M��<�iI�9e�#<#�TY����}4�����ct��ʁ��a����YO8ޤE1�e0�sޝ����[HP�����5�r�W�&ݾXB�sU����VYb����@Y��+K}e����P�U��(I��,�8@��Н:C���.`^د�y���Pø-�[;�vbX)W�x��A�a$&5����)KXL֤� �{Q5P�A�aR�t��1Ȝ����]�,Lh�}��b�Z�J� ӽA�����BΛM����`�͆����d_k�\���>O����lRd�d�p{��N��OY���f�l�϶�϶q
7~���Z�W5�#й�+�h:��=�v����Wi+�����C��}*�:tf:����U�y�r��6���6'!v�ӆn��W����f���*o~J�R�@7A7�p��6.I��w���QL!�km�f~�Р����'�3|K�hف�C��)pR�%�q�k��djC�:��~�9���;��tZ�s:�v&��OX2�A��g�Z�l9tt�.|��8�ʳ�͒����<�e�@ϝ�qE��bT�3硗!#�bF���Dhq���4�	� \mF���O������y��Q���u�u�o���/�K��/�8t�LZ�-�P�J+�@��ny��s
Ǿ𠥎�H[�h,:Ύs��hP���V]p��g��������U��4��5e��;��D�O���"�ΐڔ�"�U=lD�"��L )ni��H��H4�D@?T�H�+$�B���bJy4�;��:�Ը��^+4�1U94��JO��b�zχ�HPH���iL���qs��Q�!b�X�&i�"���3��Vu�[�!F3��4b#}i>���'���_z[
*�8� -�Ź��������@�� ߧz1!��-�B�<��Z�Y�4`�:���Y����RM+��1��8��q��a�~�k�K��Mw*o�r.O���1��1�V́X��=���S��N[v}މ��>��r��u��]����{X���aّ�N$m�A$3a�p%����%�h�lN�T>����`1�ʃ��\�y�zP�	�Lb"�A�I��((2ݬ)��O�����;��`�6�&����"�� I�pDl�4Nm��Q:(L��h�Ea���.	7B��tpY�ÃA��ӥ��P1!-LC��B�a�!������� ��r����&ߎzv8��R�'�D]�B�����G�/����b�|T�_�J�
���`�<���,�@�~6�}�+[r����kbbK����,�k�z)�v�I�U��Haߥ�W��l㰍���8���g#~+9e�C;e39V}��[!̶q�j��Bl����Xk	�����Ռ��GO7L���#�x����kz�� ����Z�����P\d��&Ak�T&�������+w��Q�&���$t��rs/����#�}s����F藿��S����/������8t��kv���{�w��lZ8Q���8���z��������˒�s����Ƀt��7N���_�n<�@���y�__|���?=�^<߉?�u�J��~erEO�ym4��V�6��o�?�'?����n���󯁗����Г��x���HA��v���ޜ�v�jS;mj�M��i6M��v�_q��_q퀴����6�Ӧv�>��������[^F>�C�*W����Y�=�rAl�נ�B'��zl��c&�N�����/�C�MQ^�l�����<�S��)����a�{�38G����Af���צ��,��93v�՞3cO���sfl㰍�2̙9�|�#L��3s.w���Ui��.y�ɜ��/�:h\1�g';��Nvzߦ�%]�  