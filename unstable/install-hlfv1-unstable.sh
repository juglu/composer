ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:unstable
docker tag hyperledger/composer-playground:unstable hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

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

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��Y �=�r�Hv��d3A�IJ��&��;cil� 	�����*Z"%�$K�W��$DM�B�Rq+��U���F�!���@^�� ��E�$zf�� ��ӧo�֍Ӈ*V���)����uث��1T��?yD"�����B�y"�Ĩ&���'�		�'@x���c����mf��[��W
dZ6v��������d�p O�;�3�f�P3�yn��>e����F��L�ud��X����i[.I |�Ŷ�-��?/X2:���2�R�0wtXJ���t6�~� p=�D�W��Z�x7Y>|�B6T�	�l��M	A_��r���d&��)�-��T@��u���ٴb��\)�����J��i.
C�Mb��.�\�3��g��	oH�ɤ����h�޴5�����h�*�Sk���{#iVtD����M�x�u�E�M�;�z��&�4p�8�24Y<���uka�Za�.sH�aSE&a��k<F��S�]��me'�(��%l�uDG�C��0�)��3łQ(.[��5(ZP�e��IZ�Ь����"\e��2o��n��+Џ	���K�Dd��3�ϟ�9�������>:Ȳ+Ń�e�ԅ�#]��C��C���C��;wS(c"�G�o��G����.6�̮��ݳ��F���-��]�.�����W�T��Q�O�4��mP'/���(�?QC���DIz�ޓ���3��Fč�]õ�~�q�6���篿����`P�H�������
x�]���*���SA��	��S5�jL��:.���K��b"�N��������*�8�1$�a�/X��a��S٧��Y�_�����/f�*MXG��;�����A!<%����_�M�p�{��r�D���?�N� ��LPbe�1�3k�9G6��M�W� ��q;-���̼vۦց6�m:���<�ll������f{�� �lhɓ�S�����3Jc������)�c7�9}��j���5k[&R�@��wE�ȎT��������Xi*8<��-�;tB-ڑ�4��AvÊ����=tg��C��t�M��u._w�6���?z,�.h���h�B$o�\
�ҟB��p��J}�+�}$������,��$6�dP��𳃨>�_������'�ۡ���K�� y:����(Hk��
���g�zy���0�h���� *0Qw)D�tC3꣗B7�dٸ���]sܑ��|Se,��}��xG��#�x����^S�QHi`���(mH������A�0l�;�Z`�d���FN6�[�m�H9h�6͚-�_��ۧ��N �5����]DHg�Easv4괇���-�[oQ�5������A�2?6v����4�.��̲�G�q�������8z�M���z��蓘�Ohw�������{�B�\��lV��]��c�n��rq��Rh�?�����t�� �y6�G�s�Gkw�1'���F�7�d�9�ic���@3�y��D6N�I'�7����gx�=���� TM��_��Z"�S��f�5��.5�+GT8hm��T�a�)#=������D�Qam�W��/f��h-��%�/J�������Հ�'%G�0�w�-�3���Ӯu�L���v3&��N�c������f�Kf����N��^�t^J�G�ݟ�nB^5�����������1���%�,��������l��8U,e�//�#��sz'�fǰ���8�Ӣ�aC��F���
�^T�tͧI(ҭ��瓏Hg�N�fKe�X>/gs��Jy~�'�f�]�M��R��C���+��1P��D�/��N��>�|΢�H��ށ�3��3xn"��nI�s9��; O\q�UE&~�>����@�u�,��N x�J���_�x*�;.��lAP�I.�#6C�+d�`��N΋軏5����k�o5����l��������e��i�/Z���^��g���=3�-�dAt�|mմK0��𰃞e_k�{�������2���?������\,_�ù�y������n���	
^v�#DCS�
E��%0��7Ew�� {pӲ2Ml�mS3l�h���st�Cj�M�u����1'{�?;���Z?/>%��1![j86{��h�|wIO���g٨h��=k�s"�Y��ӿޫ���X�M��˱�gҙ[!�.�����Աu$e#��>��<~�lx���Bl�	��=�<�1�a�!]�`����a�u��;g�����8]���,`�.Pt����[������/��Qi��'���Z�?>�_���H��
���ㅈذ��R��GgD�з�^�s�p Z{<��xz�q� ����2|�	[AF�.��wj;JC�NTY������,������`8�����/��[�#�b[Z�a��zob�)>���Ǐ
�/�U���������ȴ�K��:�w%p_�����]vCd�3}z?��v`� �|ƞ2:�F0��k5Iw��=�*��g( �@�[�v�I��,`44�mN�s7�
�m�#H�������vы��K3�-ef��k��e�`���l7Ɉ��K��N�1QG�_�Ʉ>K3qx	$fdؘJ43s�D���2f%Ƙ�0�cr�S�d�_��R��d��O��+e,���s��(�YW�<�"�G�ó�y7�ثCA_Px�onm��ڸ��������#%�'�}������
����O8,��?W��}͝s������?�������?Lٟ~B���HR0�]SDE�b�V�I�v,�UcA)�H��b�XHR��bb5�V����������4�y�_����m]#�qD6��o����m�ɷ�9.����6�y㟸����__m��I"���7_���<�{����������w���?�!���ߜ�d�jZ�xJ��vX0�SD4�`�+�����]�?�ʻpw�g�ڸ��	k��������MK����K!�����ko�5�@�n54��w�,��&�+���A�n��<���t��߹�-�N�ٲl�c��(JV�Tk��	۵��)Ru[�I�"<�V���$A��vƪb���p�4��]�
"j�F� ��B<���A"U,g�ل\N���F.�Md.	YI��n6.׳E9����=5���ۨ�SM��M�O���,{u!�nW�J
r3#��T��K�.SWr1^�R�D3ߨf�V5�Ɓ'���\q�)��1y��3���vN���ip�2S�ߺ����zgW)��m�Q}��J�jP��K���ɕS�|�qК���k(�\Y��/��\9+���Zv�ʄA�{��"^��n�p�<.2����U��#GG������O�:J+�>-�Nr�;��\��Q	��l�wz��o�իT-���N�6<	�d.�\)��L�V2��A+ߩ��gd&�L��1S�I1���$��njO�r<�l�_�b�yY*��A'����\��H���I��&�g4O��z�R;���~�%M�gѳv7��/E�VN=*FΤT/S��_���,�� �U��T<�-�5ޫ'���b..׶S�,������ľ����3�D��x�a�����v�H@�B"�i�7�=��NN�Ñ�L�B]Υ*�l!!Y���{#����O���b�X�a���&�aT2N*��X'���z)��������8Ն�l7�:��������^B�E;j�R�w���S��1����?��t����f4Iǌ�f����r��"O��#�g����^�����>���Ww�hj��=�5�h����C��B�^�������b����:e�O�\6�Gl���F�3BR�P�B�{p��Z �5����١|,�ķ(�9����N"媸_0�N��\	Y.���U���\�y����˫c�����*�?��f�W(�{ᴎ�`F�''Fc�|DA�ȁd��$��j�x��s���������_�2�t��������S��C_Ó_��β����+�q�_�d��?�즺�{��GB.�B�rAI�r
F�f*���r�M���,����Q+��Ç�t��B�S<{�����2>n����+۰[�|�,�{)���F���I���;n��{��g��� ����i`IM��{���D�#7���:��j�H�v�dq��x�|3�~ �:(�2���=�Q�Gɷ�7���=˭i������ �5�Ѝ@:4�| �j����)\�Q]�Ю؁�ZЀu��ċZVم����X�O�<,qJ�k�h�@��Ψ ��5c��W��n�R�Km��U,!�k:���t�e!HT���F`,��#��ue�ct{ز�_�x��y0�[s1�l{����.>*�2�#Ν|l�}4����8Z��23�"Vu�� ����M�j��hd"g=�=�P;&�+? 9��Z�K/0v��r)�"PFd���^���R��a��� �4a�6HI�lSC��"6`T֣m[�A��S����=��8 6�裣���(7���/lP���ay�^����$Ȝa���C�2����B�[���G�g���TDUϐ�$к�<_�7�u�W��h��w&fl!�������}?��rr��/$�妭�k�}2��;d�5�Xg蘇��%�9��ym�&�ڔ�:H����Ǵ����0&eZ�]�xR2'������`�b�Ǳ	�`q�aS>zL�B2ϲ��*��٥*4�_=�rH��������^���h���<U�.�@�u"l�0j���<����P�7�DǸI�jM�j��ʻ��x�1l�8`�S����%���)���YB��*m�r�v�|E,󵡢K�Y�߷<r�0�����'�R�d��b����l�x�?!�yL${�ٵCW҉�I�[���	!JE��H��q�	F���G�S�n&k�:��MT����1�\Eq�D��eH�P��v�!=�y�F��z$�)O�8�.ێ��ϕn:�; <,��nG,�O�O>f�2��c��&N��,���'8��V �>��9��PU���S�c16��#6ܩZ������:2�����GL��x�/J!��ٻ�XǱ����4w�S�����nԗ*?;�eJj;v��y:OWN�$N�Ǎ�8��4-�4�� v3��`�،@�� ,b�����q�U��:�շ�����s������Sq���%!�C�/��Y��K���_Q�����_�ǿ���|�/��Ǒ�q�{8�@~����?z���+�6�u]L�򧟅�P4$+&�Cr��(�b���c
ERX��p+F�
�q� �R4F�!��h>��_��/�<���D?��}��s3�����3��|������W(Z=������.�m��|�=���=�χ�ׄR>�o_>��C�|[��ނ<�.� �X�Ŕ��+��f����-K)��+�K�2��y������1K��Bn�r�U�]���]�+v������l�\�7Evg����ͳK�z���+�B�!Y�����R�<���6�.�ZE����C�9s�֫�qc[4ZW(��ߥ8�!�;�a��d�-";�}3a��ܜ��ߚg�p����dyZ'b�P4�d�an���K���8�F������c~y�^09s�E3��5H���c�_�._fǚ�)�ȥ�b��D��D";+���LI˔���Jٶ��Lt����B
ehk�;Ɂ@G!b,m͏@ד� �&k�̢��l� z���rVs|��IJ�vѹN�0��H�K���&��(L�
|m��ԇ�vw|��(�E��"�w�I��=��K\G0�y,���c5S�&ǝq8��-��<�L;q>Y�Ze��f�R�(��a���������)?VD)��hE/����-vy��Wr�]���]���]���]���]q��]a��]Q��]A��]1��]!��]��.��%�����YJ�D�-���p%��X�v�=���j"^�1�%Ne�L+Ƈ�m�C܋�YQ�\������.��T�֪��v�'j���{�yk�n�~W�Ժ�e���b2�����9n�ِ�FU���-�Y�Ū)�/7eB'�Z�V�L��T8Q���ɱ|m���9��d��Z� ������4Ft�8N����\v���]�r�[�x+"�����O�N�±�L�D�R�A��fNgʬ�֫��� CF:���8O�2z�j�T�P�dR�F97i�k�R��n��(5�.�2���]��v��^|8
�e����k������+��nx]��{o�z%�b�!���[pq�ɷ6������O�}-p������u�נNM�x��޸�#�/o���u�b�?� �>
|���~�}�
���~���0����?x���JQ�YZ�L�V:�7�����L��.�\�X��vkK�K���	�.�:?Nl�}�L؂��L�<�\�m�f�R���Bnc5�%b����u�e��&0eW���[(0Q�"-2���,xf�8�1�R�R��,�D*2��T���D��Ĩ|�:;�c<�`|��:VX���v[4��>N�Ƽ��h����ʏӕ5��H�l)�:�e��J$�ZN���9�;��y�=��4�)T�CZ��NAe�����юJ����x�81���ܒ@�[O�F�*���K�YS��l�f�Vi��,��Z�����`P�1Q�E��Zβ :�D��_6[�e�t�fNcz�m�h�*ݰ�7f�L���h��:Y�n�2{��o]�4q`(7=C�PO�<_�i&�E39�3��[����Y`xW�g6�Ē��2;�v]��x\ńk�ȅ�����E��/���z���X�Y�q�ݑ������{t��e�%�ͪ6-$����r�-{����Dޘu$-����.N��[KJ6���j�<V��D�#L1��8h�pksu^���0��{}����R�<�8}�
Wh�6mC���@���,=&^0�ݩ�9��a��H�g�==�T��֞Nhu�)��N<��Tuɪ�X໴ MO[�h^I6*J:U�ey̥K�YaBm�H��K͋E�b�+���T�ݏ�T�����pa\)���i�1^ G�����F6�_^�Y(��J��٠0���T�cLF�J!a�*1��~��LҎ"�'\�QCn{#$M�L�����Y���*�ڎ�ʤ�yW� �=��
���
�J�4>>�)���<y�U\l�%�����t�JDg�B����X�F�J�,J2F�RZ�<�t�!m��T$��N�F��BA\��C�Dʙ�x:f
�å))xQ��Nz��
�qO!�-v�����7$��P��QKQ��d�9��\�����b�<= a� |T:�v��ZF%�,���T4M���Fa�58�k��hUc���˘ɳKC+��W߲l�G>����;~��+Dxv��˄V&�y6�/![����D����܌�~�Yp����..�J�A�-�M}���,���a$��-�K%�^��#�������?zy���󈶣����7�7��g�O��3�FE�T��!q/��&q�W
o�>F�$�����Ȫ�; �=�Lo�O����`%Cr
��'��N���Z��^vy�,-�E�=@!:�'��t���½Ƚ�����!�%������Aa���F���?�C����>����m��N��`�q=���$Ȫ���N�!�\/w:a4��������|���:L�UIzp,M��b@w�#7�8��� x#4����H?��=?}��Mڟ�ݯ�A��z �w�s��y�ڨ
}-CΏ.]/������{��̺^d�c�v�W��� 9�*ms��';����\@���[O��їE�%t����E?�9@H����aI:�Q ��FL�͢���,n ��	@���݅��Rߘf��76i�,��T�.��Y�K'� o��h����b�,0( �r�S!��S{��SÕ�e��
��U#���	g�Ɠ��;X⣠C?�����s���L��� 6�zkkݧ�]E�U�3u2�߽2k�}�9_m<D�� k���I+��Y�
+��
�OV���V(���c��:Csk�^#k��UfWu\�4�������Y��@�;d� ��,0�Lƅ�^t<ɭ� ��u�Rǒv,��N`�"�Z��J.'�/�^H���b����o"l�?�����;�4luGp�`C�~���
�߮�M�.~]����W5�$���C_��u�VO�����@t:�T��K�^o��΂;�� ��}�œЀ9���V�� >������
'?HJ����i..���Е����Ë0�t�-9����.��FX���AI�\ɚ(D�����mlK���w��8l��A�DW �J���2v1�3I���VI��K<����}�ݗlةӄ��b��m�W��$x����.<�:�v�@yB�c=�4%D8h�\�6P�R�	��z�g!'AB_�� ;�w�7����0@�r$����akE���3;���`:�ՀU�X��� ����P�Is�6���[���<O-��e�5��\�Ϸ�m�\���ȴ��~d�2Q%�����cOW"�i�j�i8
��wyh}��-�{/^x�����2�&���a)N[����j��wZ�Ht�P-��շV�Z��b�����'��Ό�>9��LF}��k���	6����0|�긲�}es"w��A>��Gƺmⶵ!�q"��sNbX�XI
��<�4r�8��nI`M��P*Љ 
��b��]W�a��h�w�ƺ�������ɧ8���;��ǻv�/k��c���������!n�l���d�،�I�"���o	�8d�O�O��ڲ��17lY	���\# �����Y'h���������U���:�&w,q�
W�ei���E>���x��3�h|�k]��	p8�t�\��)W�Y;A�R;DRMB��d$F(RBd��ڭ����H�$����r��l�()�*AIgz�d@��.�?V�0+��ǲJ��'��'���-����S0T3�ڣر ބ�u���ͪ�cR�"�f����XD�d�P�-L�I�DQ���TT	IM���B�LFcJ8��%)���4��?'���>�?��1�춁⛮����-	=��h�%p����vQ��q׾`g����]1/d�\��U'�,W�3g�\2�U��3YiN;g�K"��Y�ȕJ�0h]a����������_�u7{�'�\X�dPq:#��<��w<vUn�j�}�u�sP��֎�L�3�hl��8WC�I��Fwڄ���V�L�:����`�h�w�M��d�N�Z�۹a��t&`����Z�}@���/9L��䷢|^H��\�D��ɳ<�7���h>ϱ��6O�SN�g�g\������l:T�'(��{��L����б���~��%A�gE^zz���r��	��6����V�T�$�s��<�rb5W<��=s���iw��5ֱ$�3YO������a�YV���I�lI�E����"��%�Y�<e�K��s�x�e�19��FL%c��eP�o��G��'���;��ڒ�+�0��H �:vS{Dt�NSw��kh>x6��&�ݜ��ηl�1�-V�+X��������>�<j��9$��K�����rq�+$���"��e��Ō��f�<P(����f[ǻ��^�ɻY��0�E�_�����<�����2߉���#���ߒѷY��뿏�J��&�m������>���C�[�m��>���
��^ҫ �	۔�d$|���H�����ş�{��i_����8������������������Y�F镰�����^Ҿ�?E�I�.��`Q��ʸ%;�8&7�!���R+��-��b�v�"#�f$U����aBj��/�:���U���(|��;���K���a2o��l�ԡ�GZ��Α��>GSB���:ͅ�u]��+3Nr�*	T@ϩv�k�H�K�g�R���5�lq�?�F�j���"n��e}���O'�t�7�T�����WBXL��$u�Q��8���/���ӫ������^����!�=�Cڝ����9�ǩ���>ҫ �	l��� ����%�/������ �����������>�=��Ծ�)�J���?��{��xd���`��%��^�@��)���A������ږ��A��#�Z�����_ڗ���&�-�O������:���+�N������޵Z���]�cRAp��]L"N��(���$VuG��JU���}��RI)��g�s�Gu�Q���ΟB-��`��?JA���B�_�������O�� ����?�V�:��v���C�o)x��7������)u���e��~��:!�-�\���,*���5!��Z��O�gv?��!ZG����u����g���Of��������'�4p��
�\f�P�ga���f����ϭ�4�T���sŖ�U�
�|��5��Nc�!��ҏ&�͏a{hӗo����{���O�G�>��~�e29��{�`�[w�F�.���>�$9����l�nɿ��ϻEse/��ԕ#m��8vE��gӻF��b�ҴP{�HTړ�oS�{��~ȷ7,L=���˝���%#�LcG����L�Z�?��W�迧Q� ���_[�Ղ���_����U6jQ�?�����R �O���O��Tm��@����@�_G0�_�����������+�S��e�V�������Dԡ���������u������u­c>��3WUch;�~��+��������ϝ�謉_�#o�����2y��'�[���P\i�����Z1ܥZ����.�8)�����=EP�Nb7�Θ������R�7ۛ!�뚜=���_����������wD��s���_��+	��6>r�㿷�o^~��P�J�x����X��.i|JI��Ηڔ�	:!�Ͷ��Q����u"��p暤 ���n�Prd�
'��KF�h�O������������+5����]����k�:�?������RP'�f��3
|����<��P��I���g}��	�f|��|��i�"8�CC��qԁ���C�_~e�V�uq��d�l5uɒ�=�
y�A�΢�M���_����͑Ώ�<?�(��U�,�LL��t�sv��i`�M2_o��v�e�K����s�^ڌ���?l�'�:���^�����ա���~]�JQ��?�ա��?�����{����U�_u����ï���![Un7㈉L��g4�r����d�p��O�a�n���#�<�A3f\���].ջm�(�sd���/�'�D�:�2B?&�=2�U.tf��e��9�g�`l�<��M�s(��ދz��q�+B�������_��0��_���`���`�����?��@-����?�W��Nq��=����Ȼ�a=az'	�c�4������|p��om�rQ[�9 yz�'� @��g�p��~{���C��\x� �8�rh�|���'�Z$|�.��4ZMA��J��Y��4l���7"}8�1ꄗ�C�]דv�)看z3vN�o֋��s$r��n�<�k�����g vK�5�R�Hn	���w��]�ӌ�A���#A�X��ﺡP��HaY}�'�~����ib���`sMh����r&J��R�""L�������dCT䑊��C�j���[�Bc:U;BOg��� 	=�nGd�-�=>!�ͤo�E��W�u�u��~���<:	:���VW���z/�A�a��G��+���]��/ʸ�o�������`��ԁ�q�A���KA)��~�EY�����O�P�> ���!������`��"���0��h��<%Y�	� �C�G]�u]�&��AY�	���A��,�L����b秡����_�?��W��:}�,�Ԧ��c�{�hċ'I�ɹ���kdbP����9��IɃ�i�BK6J�A�{l�Cd�&�~��ݤ���������6�yFͶq�7މ鴬]%�-��}/�p�������S
>���U?K�ߡ�����&0���@-�����a��$���n��!㽎 �����/W��*B���_��?h�e����4�e����k������f�7�ASh��	'�re���E%�����e\�#?3�}}����k+����<���S��N�� o�~��z��<��6JzGF��Su����4G�C�+t6��xĬ��lꪼ�r3�)�q'�%V7%ӂ��vH�܎ruaYBO��6r��J�Y��kۉ�w�s��A8d7�-su�M�f�+n��C���x�ꐮ{��ʎxM�E��L5hD���gMC�u�s���i0�B��fl�#�(�H�LJ����=I+�SWVr�c&2i����g��c��C��c٥������ߊP������
�����������\��A�����o����R ��0���0��������,�Z��������������ӗ�������$��e �!��!�������o�_����!��Ъ�'�1ʸ���I��KA�G���� �/e����-T��������
�?�CT�����{����Ԁ�!�B ��W��ԃ�_`��ԋ�!�l���?��@B�C)��������O����a��$�@��fH����k�Z�?u7��_j���R�P�?� !��@��?@��?@��_E��!*��_[�Ղ���_���Q6jQ�?� !��@��?@��?T[�?���X
j���8���� ����������_��/���/u��a��:��?���������)�B�a����@�-�s�Ov!�� ��������ī���P���v�2�7C}�%Pv�r��'=��H�/$A������.�2.�a��r.IR����z����4�E�S�?*�K�U����v�Rq��T�
m4w�ހaD(�佞�&q����8}~���$�����jI�_Uc��C^y~�;��a��T��E��F1"��*ixa����}6�ԙj�B�u�v����N����C����d�=�c��:�y���K��'U�^3�����ա���~]�JQ��?�ա��?�����{����U�_u����ï��>�Q�ƾo��FM�}�7��b���_���i�Sy��V�ܛs�M�߰��n��� ��E�C�*Qx�N-e۴�����|����v�դA���f������f1�˔��{Q������������}��;����a�����������?����@V�Z�ˇ���������?�����?���q,��91�ő"����_+����Y�]��$8���Ro�X"���#Ҟ�[���lH�%��I�3M��`$H�v+�,���z�ڽhL�Ì��0R�/�=������^D�dA���gZ;ɑ{m7�^^�k��ӥ�����rM��vB$�����_���@w�N3���>��c�b��B���E�I�0��N�jv�,��l�J�9y�����Ǽ��#b6P�n�8B֧�ə���h����ǂ2���zn�`A�\���I�v&T#<l�es�I)fk�����I�OvA�{}x�;~���28�K�g\��|���'.��_�P�a��O��.���Jt��ڢ�����O��_���8���I��2P�?�zB�G�P��c����#Q�������(���{����F����A�8��]B�������?Zo��?D�u�4��ώ�t�Q�^�
��Z;������q������K�7߿�.]M�n���j]^��kj	��ؒ��[B�8����u�!�ԙ�a�#_�FF�́�(u5^��Nn��T3~6�٣c�J��E�J1w�s�ToR¾���ʶ�ѼM�
�p������'�nѲOVޓ��No�����B4��_�?��~��7[���NS���� 
�ݛZ[�!�M��!6�6�u�͎A5!~��tI�c�r�#��K���>��&+`٥�t��`4���L�Ӏ?�r�S!���H���n�Bn����]{�&Ч�Q��ܔ���r̙}i՗_��Z�?�n���%���x���ž�H��f�����I��f(��8=��Ip3�`<ڧ|4�8�Q`���P���~����`�������f|���A�<��`7y���8�ݓG(e�sG_����ʟ�
��rU+0��^|���j�~��Ca$�e��c�{��_)(���_�Q��������h���-��W\�?������c��ba �Ϻ�'t0���?�*������@��SO���`C>��-���!?��]�?���D��׿�~7�y��g���B��:́�nCJaka = �G5�֘�_��7�4�5:pbu�Ӽ��B?K����|����d��F��vGW����w��������:�f����G�ٻ�d�+��,M[f2��tY�*�����Ix^&m���z=�P+�0�rҿ�(JyM#[/��G��Oռ�*E3C�a͹�	��*l8�Mo�,�d�W���ܝf���}����G�?��[
J��S.�~H�,�3ǯ?��|E1a8�<��\�e����]���8F]�X� ��Q���q��x�����|�J��ա�i��vN9q�4\��9�v���}�7N��w����e�U� �-��������~��c��2P�wQ{���W������_8᱖ �����!��:����1��������w�?�C�_
����������ƴ�T{mh�^Of{�,:̇���/��5A��?�^���*����Gi��o!
ȷ�@N$K&4iz��Y��g}�\S���=��r�ֹB>ں�u����+��忧�{���&�����+�9�S疧��<��ɭT���[�r �(�������Ig&�f��T%m7����^k�֮k+}��u�ו��^�y8���r�θ։����<t�v�Ѭ�uݾ�z 
������T[UL�=��,�mfe��mW�nɑ�+b���t�j5��^����������RS��y�g)J�X�{�94Y��vŮ�{{m�
�x�mؒ�4l��[edK�ڼ(��O��*���Ƥ�1���T���`8��j�߫�X��x�mg�j���G�+�$�ek%�������//��JR$=���WRO?s��?M�?������	Y����^�����<�?����,�A�G.����O��ߙ ��	��	��`��U���C ���۶���0�����
��\��������L��oP��A�7����[���տP_%�[d����ϐ��gC.������?3"����!'�������+�0��	��?D}� �?�?z�����X�)#P�?ԅ@�?�?r�g���B��gAN��B "+����	���?@���p����#���B�G&��� )=��߶���/^�����ȃ�CF:r��_�H��?d���P��?��?�Y�P=��߶�����d�D��."r��_�H���3�?@��� ����_�� �?��������m����J���ʄ|�?���"�?��#��!���o�\�$�?�@i���cy�	�?:���m�/�_�.�X�!#r��GS�I�%~�jF��yn�[e�dK�[�k�|ɤ�3,K/k��1�2�9�c?�ou����A��ܥ����������Q��������]�bS�[��d���$=���uQ&c-�vm�;mL��-��8��XPkq��4_�*�#6����vSZ�t�z�t�v����tX��vX
����5Za-ɜ��'�����5�7�ݎ]�F���-N\�vI��J�=(�Ȋ�:�����B��9#�?��D��?Zìo�C��:����������D�
�K��?t�H�O��&-�j�=&&"��|��3�-�^O���j˝=�?���h՞�ڃ�F7�Gnk�5lX��a�p����X���;�U/Ķa�&���1�W��R�ڜ^ɁM<H�v*�$��^K>��"��"e�oh�F�36�_�\�A�2 �� ��`��?D�?`"$��]����2�������g��ݲ��懶����ȑ�b��:��6�����S��5q&S������׃m���6�T����]�$�vw�z�k�h���I�/��a\�X��CҚc����̫N6����ms������v�R�8��X�q���uv�O���U���-�V�_��v�&v��c�B<�~������81����fU���J��ɇ������	NU��ө�l����Qk�2���r�0�Me*�q~�����)�ұ�q $��w�~�4d�����݁��!�Z�~Є^맷�^���b��*޺���=rJ������+�d�?� ��_���A�� 3�z���	���G��4ya��<��H�?MC� 7�?�?r�������O& �����n�[����3W�? �7��P2{����������@�G���o�\�ԕ�_��2��+@"��۶�r����2r����#r��s����d�7�?Ni���9�C�J�� tĎ8>��|o��-�"�Cd��aĵ�S�G�>�~�����]=�~����܏4�{E��)�s��y������~�E'�׻≪��'qj��w�ڲ���3�7���joHE��Ά�̜���i��F��qt�1BX�Ƨɦ�ڎ⫣4���y��i�ؕ�_M��6�(�#-� �
<i���p�Lk}o1���$4��y��31���D֩�b�ٌ(r`Nxf5iK��&Y�膛�06�FrԦ�^�dحX�]s����l�>������\������������d ��^,��-n��o��˅���?2���/a Sr��_��E��&@�/������Z����D ��>/��)n��o��˅��$�?"r��W����&�?��#�[���������n�^������ʥ�ڲ������?|�?�e�yx��76�����~/ {��S@ink��1`:nC���R���=U���v��h��Y�|�o��D{�DU��4�-��т��ڡ^���V�˲B>������$�?���I ��Ћ��'(���.,�U_�R���D��9W��[~҅E-,��֞,�]Iٰ�i���Z�L�a���t���C��9��[�ۊ���ӻ��\�ԕ�_��W& ��>-��%n��o��˃��+����Y��g�ohE޲8���%͜I��XR��bi���R�d)�"5��,�0u�3�%��s����ߟ�<����?!�?~���~���-�әϟ��L�TK���^?��zm�Z��iT.<��y,�	M4�v����v�?��^�ט�b�x��EMk��s�;���<;j���i>��xR��@���!��h���<��P�H��t(�p��������Ar�Z0qQ7�M���?���ǻ�x���Y�9�U����b����Z��N	_����}����td�����}��4v.�&��zh�Y̏��ꈝ�����1?��Ӯ����e�`\������M����eh��^K>����/�g����������E��!� �� ����C9�6 �`��l�?D|�����-}���ύ�}�"��G�-�^�t������i��� �y!��9 ���u�����-H�T+[��z���jQ3G���OelE���GG��O��bSl����:��C��CU�S�Y��m��$�N_�yXj牚׻Ov��x�J#��bwX�tL0���&�M��|�ZIItr��=l����FC]-UI'd��Q88V�UD2���{�������f5��k�a�4��J�Ӷ�g{��p�HS��WW��S�f˗��'w�.9�
ǵ=;����Ŋ��?<`���Uh�������jcD��Q����p����L�������G��s�����>��O2������L�;���s�t��h���=u������&Qԃ�^Ğ"}�j�ǎ0�x�W��~�!=ܝx��6q���i�M9���	�;o��H\{�
��t�����z����(-4�5�χ�39��?/j���ܱ��k��?o~�K>�7����D��-����>���}�A�|������"t�%t-\`������p��-'#�/�'����z�>1͝��XhF���O�S1#�H6'�����&&������\m����?��@��ha��.��xs'H���#VQz޽�n���G������"
���~{ؓ��K�߯���~����ϓW�Q�Ƿ����w��v�������y�"� ���w���ė��7��m�����yz������x���ڜ�f��'<��ǧ+��q-9�g��>��E"|��u��׉�����N�L�KA�����@iV������ �$w����0�Xx��_���+�M��ͭ�ٝ��%>I����s0�7̀���z��?��y�8��ï���'Y2诅9mnb����ȧ'�z��[���������*�Oj��;�j�c�ߑڭ�"?vr'�&0��T4�k~�I��^�0��t���/��L���{���&�(                           ����HJ� � 