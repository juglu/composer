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
� Z��Y �=�r��r�=��)')U*'٧Y�Y[k���(m-x-�/�,�>�!0$!�R����	�*?���?�!ߑ�kf x/�%ѻk��Dzzzf��{=M+-d��`::�7L�j����b���K��
�$>�b4�����#A��I����X64xd���Y��=��B����m�Lz�q2����m���	s�|��j2?������ֆR��w��#�������H1�6m�%	@ <���m��+CFW3��F�=DJ*���A1��m�� \��(�
4U��o'���mdCڐ���`X��?DȔնf�/�##�ĺN�ͫ�P��ٴb�zTɤU#���\�vb�	�.�\��3�f�托H��H�����fc���fjʢ��RL�Ci�*�#aYVtŠ���M�x�u�E�-�?�z��&�5q�
��M&O%��A�Zخ�Fء��x�T�Ir��Q��c����Q�C!�r]�vGG��q!*̟v
��B���+V���@��j[�|��90b�r�WY����Ӷ;��
bBw���e*2������`;���Dd�G���i�ԅ�=]$�>M�%�|S��O���-(c*�Gׯ�F���6[�Ĩ��3$��F���Y�4c<\�s����T�P�O�3t�mP'/����(��_4,�/"��@��9�_��7c�mD�(�3\���wm��t������l$1B��xD����U���B5�ՠ��,�
���@Q�?U3�2I>_%�����Q9�y+��`��:=�|
}�1$�/m������O���(�����/f�*-�@�s��;���=�%!:�����_Н��˽.l��{��E
��[:}��2A��Y�ƀ���Ӏ:6���tܡ'a���l�qL����Zڔ5�t+2y�����G ��NC��]����"�X�����54���X���>��Dy��MlN4��.�� �bm�Dk�( yP��lC��V�kx�eM�JKiB��������(#�a� �l���]���o�ơ�h����Ժ�o8z�=�AW�C������d"���.J�O�`"8<D`��ƥ�>����}D&�{��z2�Cj��Ӏ�M���?Y�����]]�%��D�N��� 
����
���'�zy����Mh���� *0Qw)D�tC3��B�W�l�y��]qܡ�����Dt,���iu�z��"� ��<޿�$� ���Gڣ�!i�z;< �K?�ؐw���d���F�&��Ks[/�N��I�f0� P���(f����ޒY Z��	�\6f�#�=�&�m9�n�Ek��1�]Yb�i�]��;�>3�l�s�2��:���}��=�"��)	�g26��4}s�	e�>�X�:�G.Lȕ�f�(�*&�v����V�;�������t�ؠ�Ԕ&�̳?�s?Z;ϙp��l�{��@�s�6�or��4�N�G��Od��0�Q�M>e8���t�L�^P3l�z5B�j�Gt����
�5��.4�+GT8hm��T�a�� ����۟�Ģqam�W��/f��h.祉%�/F��������Հ�'�G�0�w�-�3���Ӯu�L���vs&��N�c��Y5����>�Ηw>a9᪻�ʇJ��?���L�&�U��=Ϯ���=�C<�,1g9pI�ܬ�,�S�3�J����b0r�=�whp�/��n9mڀ+D�/h�����qH��|��"�
<{:��0Kw*���T�r�C5_�U�s=�6�w1
�[�L�jm^��D�1�����&�y���B ���S�G��}��lx��੉����ߒ0�r.�۠H\q�]C&~�^z��R ҺtL�ttz@'�a%BF�o���%�;.��bAP�I)�#6c�W���FÝ��wkpk�O�k�o5����l�����}��e��i�/���p���=�T���i� �� 蘨�]��'�}=˾^u�3��_�{���9�#�u��
`���Ν����O���%p���KP��!���p8���+������ك���ib�%蘚a{/D�mh�V��;� �Rk�l������O��8������af?��y�)Q𓏉�Jӱ��?F���Kz�E�X}�Fm@����!ω�/22��ҿޫ��X�O��˱�g�̍�)��߱w�:V�N��l�=1� `����/��W�+�6�2��Sȣk2��b�E
V�x�L�_O�s����ޙ���k8|������v�~p���.A���<2}�S�o��?<�}�򑮚+\�/DĆw-�,|tFT
}{�kAnDk�ǁzO�:n3�BP\���[a+��ަ�wg�Vm`Gi���*��������e��Ħ�_��������qY,c[k4mP�����O�	���f8~Tq~���M��./����Ʀ�?��Ww��y���f7D�;�Ч�C
��6 �t'`�9 �ìci?�v���yT9�3c�����(#L� �S�Q׀׵9���*dm��A� ~�ᨍ���^��]��)3�\��l�(U��6�e��E�^�/g�t^��:�%�L�4���5bFZ���@3�eL�>�!cV6��
c	0&�:�=����A!3X�6fyҔy	Rƒ��aA�G�����uui(c�	-b
��I�ꟕ̻��^�
���#~�pc�?\�>��۟��q)�>�_�z�G���<�em�	^p�W�Ƨ����:�s%�������7_��o��?�������)���O(\�HDJl�Q#	X��#�V"��RD�CQ$I��#�h"!��[Q���n����_��	o���������_�#��m|��5o��}�q)lXش5������m-ب����j�/_M�����jD��߳w�ƿl��7�������t��Dp���$�W�����c���~�8N�h�1�`����f��w����<�[�q��?,�����'ο�c�&m,Y�����	����
���X�YC�VCSI�����7I_�N�t?����|�����oizΖg�OPD1aM@�X�.(񭰰U�J���m)��F4'ܖ
%(n�a�&�!L�H$'Mh>�+^AdY�S+@������E�ʔ��l>%W3���Q��S��TJVR��Oʍ|Y.:�q�E_%s}�&��LK/�R���>�_���S.3�������Q&�,����K��l�	�j�Ul�rz�~����E�\>r�)��1y�%s���uN%��Tں�U�7.�fr���e�9{�l��$��J��&	�i�8�jF*6��환�ݦR,T�^�</�y᠚�Nh�9+�e�d�P�z��i��T�ez���.3�8ڻT��W��<9�*�h級9)$Kn�/
�wƑ�u���I��)��.3�BR`r�wR:)��$*��0
���rY[�]���b�VM���Lr���\�IȍL.��>�2�����9gk�"Ys��J�p������t��<j��dN����]c�ur��G�S�'�e�ZѴh!~?���[�J<o��r�,������j5�_�#d.�j��I�z%:ǻ��\�c�[.$��VF>��Bʢ�R�R��ړ�ɶy�x2�L�3��~�����i�ÃSHecMz�%R�d����`Jr!s�ʗRk�{g�2����)�l��D�$jg/��|U����q��RC�|�݋�v�u_�Y���L�WHĝ�;��qa�
Z?IĻj�,�3��g��j��`(�i�}�h=�3��3[?�_�ܐ�/ �bL�=����c{޲�R�D�׵;@S�|aE�d��~���:�o%0�'����8���)+}��]b��E6:�z��P�RC�����B	�U�=���c�"�A�܉�w�l)�归!9M�r�d�lvSV�X��Z�Y����<��S:~QC��\�u�/���hVGѣ�])�5R��c�z !	*r(}���ӻU�Q��ą�cη|�;��G�����n��k��
�l�ߩ}��/��K���:��J`��%��q�m�2��]��#%�����\Rҥ����ɦ�`5��pq�pB��^7:�~���Y��� �)��q���DcwĽ��֥m�mC>���ֻ��Q�ô���7�Ӝ}�Q���'��ccXR��>����-������hd��q5��p�o���|�@��� �u�i�ʈɅ��(��������6����5dn�Q�[�G���F ���Fu��X��Ө.hh��@�mh��~�E-����}�4��=��%N�y< � (�_�� @��fl���*V~�mS�|��6�� }�@GԐ�{,�.5:�K0�@�0VF?F��-��Y Ov�_������ȶ�!'%��A���I�tx�C���?2h�-����,ӑ�I���W��w�l�Wc"D#i8+�c��蹆�1�\(�X4$�G/0���r)�"PEd���^���R��n��� �4a�6H	_��!���0*�Ӷ-��DP��T誧oO�4��e�����bT�L���)��Xа�|�t҃ctRd̰�����d@}��B�[���G��#���cj*�K�Oph�T��/����Kwv�I��#������A�|s%y0��r����>�.�����ی�g�4�$5�Q!�͗�DV�
Z�������j;=�u�I��v'E���̉�u�2>�W�S��86AN��7���T�-��,����,ՠ9������>��B\;�݋�\@D�ml"o)a�f �:�h5�\��A&x�ׁ�u-�1n��Z������n-�.<)�v@��)v�����r�f��2K��J�/ݫ�4_�|m��<���9����;t�I�ti�MG�]�TU��x38��EL4�_ٵCw1�C�J�ۡBEw,�Ed���05l7=zޒ�f����F�DJ��[�kh".���h�1Th�=ͧǘW��k�G:������i�v3���M�}D���ʐ��%���<����`s�����b����7�		��@E��,��Xc��L�>P�c16����-�Dz�o�B[A�#&�X��#aaz���u��J����%�q,-w�4������3�j���ʏ�Nr��ڎ�Ĺq�Γŕ;��qc'N�@�!�@K�4�� v �!1�0,����b�!v�|�q�]�[��i��{��>����?
��_R?����濔��ۓ����O�?W���|����o���~G>Ǒ���������譣A�����5t1�ʟ~�Bѐ�H��*�X�
G�r�)IaM<#íA*dT�	�lK�!��_H�x���~��|���~��W~����������8�{�],�;X���G�^�h��߼���� ���~/��� ����"_J���?|�0����v�m����n��b�S.Z�����n4Z>6�t,��z�l2,}�t:��~/�/X��,�
�-��W!>tUC`Zv�P؍��Z3�XsA��ٝ�V&6�.iB���B�@
��d=[��
�3DH	���N���HkQ(
&g���1[��ǍAl�h]�X74|��L\�����ns����L(�̈́	3�rs�k�T��*n6��i��B�4���E�y�W/��3^����3l��׏��iz���y͠:� S<���S|id�|�k��t"�.T���~�.�쬄��3%Y,SVF�+e�B3Y��"��)�����$����5?]O"L�A��	3�v�I�ْC�Y!��B')�yD�:)��"}.��F�4��05+��"S����yx���*�4߉/&=T+��.q�@汨F.��L��w��.����43���dMk�IJ�UKe�H'�Qz6nRbnn�'��X9�����������\�Mw�^"w�^"wE^"w^"w�]"w�]"wE]"w]"w�\"w�\"wE\"� ��0�.�f)E���O�J�㕌Rb��9��7��x1���8��60�.��q/jgE�s�*'�K螻�<R�[��۩����@���������A\�S붗yj:Ċ�Hz�3D渁gC�iT�r���f	~����ܔ	�jiZ=G0��S�DY
7��&��	N���Hj��j�����&�'����8c+s�ٲ�#t-��Itoi⭈�Sf�[87/T?:5�r82�1J�a�C�9�)�fbX�vb��(N��<]�D��eS}BᒹӊJ��ܤ�Gd��J�~�̢Ԁ��˼[�w��ہ_8z=�A�(���G�=z��r�?� ���u���n�}���o���&���G��Z>	�s������G�N>��^�:5]���/z�����x#�ׁ�����[�(������+��o<�S�|�㇁<|���<��+EYfi�2YZ�|ވ�r��2y���r�b��ۭ-�/�/Z�'X����8���-3a�3I��Pr!���Ky������\�-�
&�qD�ilJ����]	���o� �D����tZ�������x�BH5J����Ȕ�S�cv�W������T��ln���z�X`��z�mQt|�TZ�8i�F�֣��6H�;*?NWFx�Dj"���L�x����+�4k9M�S���4K��� #�@��P!iAf;��3R�[T�F;*]n'���HĐ��sK�l=Qu�4_�/�SdMQv�)�e8Z�՚���k�&.v˃A�D�	�k9˂�`d-�~�l!���9m�����]f�tÚrܘ3U���-^�J�d�G����ǿu%�ā����B=��|yP�����δ[\n�����e��]���4�K���� �u�#�q��"��"��Y���j#�o?c�gf��e\vGn��.�#����u�{����7�ڴ���
G�[�e:��Ɇ�Vyc֑�|&Oԓ�8�Vla8,)�zܯ���X�.}6�0Ōb4��í��y���è���F��J��lV��*\�ڴe�6��M��6���x��Gt�:��Sȇ�N"5�u���8R힟Z{:��A�|�W:�dZ�R�%��b��҂4=mբy%٨(�T�/��1�.Efi�	�ys �7.5/E�a:��&S�v?�Ry.B�[Åip�X�1#�x�E��³��u%OdE�H+E"dg��xXS#S�1�+��-��l��U$#3I;�d�p�G����4�2An{�*de_�L$k;�*�"0�]�����W+�Rz*�+����X��R�C��Vp�	���c.���*�5
%�Cp�cq�K+ճ(�<Ki���M��et:S��;�
q5��)g��y�)�����E}h:��*��=����	җ�BJܐ��Ba�nF-E�N���|��r�J7D�V����l��5�T�Q���a2j��4�cSi�4���%��P6�-�F�U��r���.c&�.���_|˲���w��M7��ٍ�/Z���.�����<tlѢ���*8r3>�e�g�i�2ԧ��+����7��6�<F~���V��.��{����ϟ?�?|�<�����#ڎ���D� V�>E�΀oISeۇ�]�@\ӛĕ^)�y�y��t���:#��� ���#2�q>A~����)P��8�8uG�g��{�y䁳8�,O]W� x�|�`���ҡG��"�2+G�k��t�t�� Od̯����������H/���G/8���A����ד ���
�;��ts�����T�
�/�Vf��z�;�0V%���4���Ŏܸ��;
���4���3"�_���926ifw��]���H���I�S�k�*��9?�t�l�㧫���3�z�폭�U^Ѣת����U�ɎN��h���s�cj|oo==VG_Q�lH��z?<�HPP� !=����%-�8F�G10E�6��'
,Բ� z& 1�"v*�2H}c�]\ �3�w�ؤaв�S�� �fq.���Ի��&������ �˩O��/O��jNW@���+��V��&>$�MO��`������z�_ g�ADVТ3��1���X뭭u�v �w�W���h~�ʬ��A�|��,] R�̢�'���g�*�L�*�?Yu�b[�h���%���q��{��юW�]�Ip��:�z�"�gm�}��e�tb���2z��$��6�O�aKK�I�8�j8���jQ;�+��@��z!�g䊉+�������ԃ��?�0Ӱ�M���	�����* �.6��u��~�_�/�LF�}=w�_�1t[=:�� ��`S!z,-{�Q�k28� ނ��>�)OB�P��Zm6����6o(�� )�O◧q���粫k@W�g/"��B�m��p~в���dM`e�%�s%k�hٺ2�^���-%O�{��Q�� 8\�a�n]\*��/ ���P�$U�/cX%m �cp.�bz��v_�a�Nv �ݶ��^q�Eo���#�c��� �	����ӔT�=rQ�@�J�&(�񟅜	}�vp��,�]� _�.� Q�6����*�u�ii�~��@����`WV�ce2����C�&͝�\2�o�nZ�<�t;h�Y�$�s�>�n�	r�#��[�E ���D�4kX򪋫�=]�8�	�e��X4(0����.�lto�x����c��� �ކ�8m1���j�i"�-B���W�Z%kݶ�����jBH��:3r
����23��z�:��:�k�'ش_@���1���^�U�͉�	�C��	�z?붉�ֆ�Ɖ�S�9�a1b%)��������_��$�-4egCi�@'(�w���w\qpl��b��Iߑ���j�����
$��܏:�����������������m�����+���b3�'�`��}$��!>!>A@j˶Jv�ܰe%�vr��h �oó�g���"?��g 2�3T1Z�����Q��+\����*vt��R��Y��\��ծu��'���ӱrEC�\�f�H!K�I5	Ij���HdH	�m�j�ZJ�#m\��f��?F��v���p8�H%��}[�����DX�ì�gN,�*�����l�Ƕx�O�'O�Pa̐k�bǂxf��W7��IM����&�bY�qB	�0)&IE�cJ�RQ%$5eBB
Y3�)ሂK��X|Ҵ�����c3�D���̲��o���7�;�$�亣q��	Ovfߓ�E�V�]����wd��cw���msE�+ZT��\�Μer�W�2�d�9�\��/�\�f�"W*=àu�]��[�K'�r�3x�E�����_pa�A��P���3���U�A���.��{��U@@�[;�3�Π���vF�\�'-���i���Z�3��b��-��o�A�6io��;]k�nxl熉Bw�!���V7g�j}��nz��0�b�ߊ�y!��sEy��&��W� t�>���l<Ǯr�<�rL9���"�qY6����P���(
�Y�3i�N�CǶz������Yy��?��m�&<Z�����ZES���e|�,ˉ�\�T�F��e�3����F�X�>���d=�k��bj�g@�=fY-�&��%�9�'K�4C��gq�e.�ϕ�)�q����N�1��E�/�A=�-�O�8��L>kK��\����"�xc0��EL���:Mݝﯡ���,���vs��:߲]��d�X��`��2V��~��0���{�F.u���N���ͮ��;V�ߊw�#�9+3V���@!t����3��m����zq`�&�f�_�$9��G���o��6n��!�|'뿏���KF�f�CD?��>�+���ķ�c���H/��MoI�	zH{H�X�[�*t��{I���'plS����A��#�K�ß��i�ʦ}��K������_ �����hhh^���f��W��#w��:�{I���9&Y����E�v$*����l�Ȗ"K�X$��*�EۡV�����pTib���	�u��,��j�Wa���m���k/�g�m�ɼq�O�}\S��:iet�:G�+b�M	�;�4��u%?��8ɍ��$P=��E��"m.U���rH!2��@��E��-�=�ޖ�����y�?����ޤS)N�Z*^	a1eV��a�;F5��؟?Y���WA����/�|�ocC�{���;�c�os��S���}�WA�؎���A��#�K�_������A��������?29��}�{�� �}�S�N����.���������Kz�?���@�S�����?��{��$�-�����Gz��?�#��%���/��3LP[����#BuBuBu�DC8�^	�߁�����;Qt۾�+��c��/{��MEE�/{ "�((*ʯ?�Ī�hwR�
Е5�RV*)E's͵��`���@��.�������j������I���~h�C�Oa���8�������Z��o��R��/X�n��.�	�li����gQ����	�m�Ӻ�~"?��y}�:ڇw?�����v?��|2��ȧ��}��>���c�T���*k(��=�Yo�h����P���N�LŊ��Pl)��8��~�;���,�VK?��6?��M_��Z�o�}��>���l��x�dr�������v�8]*_$$}4�Ir�M7��"ݒ��)�w�fl/��ԕCm��86��FԳ�]#LI1��ҴP{�PTړط)�=�M{?���?�m�O��NU���c����l�n�A-���+C��ӂ(X � �����j�������H�*����?�p�w)��'���'������p�e��/�B��
P�m�W�~o���)��2P+��MP�"�P���uxs�ߺ������:��1���9���G�N�߸���~u����)�sg<:k�ߗ��[����c�LC�z�I��`<��n�����]��Zh��Ҋ�r��Q9�S%�1��$v���9ٟ
;/E}��Һ���SY����x�ϟ�z�y'@�x>W�K�� ���i�#�>�{����e��d�w
Q	������7����b�M�����l+h5���['��g�I
�\1��F%G��L�ĳCq�H����_�����{��0�e��o��}���� P�m�W�'^����_
������1���f>Jc3��<��P�� H���g}��	�f|��|��i�"8�C��qԁ���C�_~e�V�uy��d�l5uɒ�=�
y�A�β�M���_������#9\=yqQ'��YL�������V���8��d�����)�B9�$�7@� �yi3������wց�����������1t}+E��P�U�Z�?��T�������RV�b|Aԁ�������;�lT�q܌C&4��3��|���������q�>eYr��r����H͈q�sFw�T�]�h.�ynF�(�]��0���H��l��\����s:���ؐyT%���PP��������V���}��;����a�����������?����@V�Z�?�����������B�{�� $�m�w��z��N&G�iz��?[V��_�[�k3̐��Z�� �Ӄ?q �g=����T�ۣ�_��*r=��3 x�8Oȡ���Fo�j�l��rvsd�h5��+��fi�Ұ->���Ǩ^�5Jﺞ�O9�\ԛ�[r�~�^���#�c<�w���)\s����x=��[B�	�z`'�rK��O�_����>��f�}	��b�~��b��
��>a�3���L���XhBClm�ؙ(��K���0y����|^�Q�G*��i�����ө��h:���I��v;"�l����f`&}�,4�׉�!���6f��$�Xs|^Y]u;��hP����	��|���wa£�(�����C��?(����2P������/��?d��e����?��B������������6�	����P���8ף)��<�dQf��0< }��\ץi���ـp���4����$`.����i�C��h���O)���N�;�
%���z�X8BE>��I�sr�oGdA��T�2�k%o����l��Ԓ��v�ö��٬	��F�|7飸�0���yD��MƂ#��ᡣ�6���;�#����ĺ��E������J����5��g	�;�q�?�������w�?����r�ߝ�#�x�#��������U����P:���/���5AY������_x3��������������)��Ʉ�yw��~Q���Ļ��o����~_C~f����F�q�;���x�w���S-8ț�����k�N����ޑ�'�T/�=--����
�Mo51�ОO]�W[�̌"Jc�Is��MFɴ�`H;�|n����,���d��r������;ƹ���q����V��ަk3���ߡb��"�KuH�=�Oe��&ۢb�d�4"��ֳ�ɺG���b�4I�s3��wg�P	MJ����=ϒV"�����Ld2�:��"�1Ǚn�Z�e��:迋ڃ�+B9��w�+��������c�V�r���:���i��J���7���7��A�}����X ���_[�Ձ���_J���/��jQ�?��%H��� ��B�/��B�o�����(�2����Cv��U?O�c�q�?R��P���:�?����?�_����c�p[�������?��]*���������?�`��)��C8D� ���������G)��C8D�(��4�����R ��� �����B-�v����GI����͐
�������n���$Ԉ�a-�ԡ���@B�C)��������?迊��CT�������C��2ԋ�!�lԢ���@B�C)����������� ���@�eQ��U�����j����?��^
j��0�_:�P���u�������u	�S�����?�_���[�l��(�+ ��_[�Ձ��W�8��<ԉ�1�"=4`ho��K��傹Oz�ϑ8\H�fg.�$�˸��1�˹$I1��>�����O����O��`��.�Tyz��۝K���S*��ܽz�����z��DM.Zy4���jb�@o������/�����!��<?��̰�a�٫��L��k1N^"�he��!u�Zq@٣ގBq1��Ir��x��>ߔ�ù'u,4X��H4�{iw���~�k�:��!��:T|������u��C�Wj��0�Sj��Ͽ��KX���Q����:���o�uj��V�jl��7z�@�,�bؾ��68��|*oܗ��
V{�`�z�$����,��1�,PD?��'��R�M{z�ݰ],���o[M�	<m9J��A�n���L�P�����ߝ��oI����w��w��k�o@�`��:����������Z�4`����|�����>o��S�_����Ɉ��ޘ#[Y!4��\���_�����U�I�#8m,�V�u �?"�ٻUj�͆t\q[�4;���F"3�ێ#�������v/��0#Ǫ?�%��b�m�D����)Y�þ���Nr�^ۍ×W����t�����a��\.�-��㗼���,��]���A���#A�X��ﺁP�C�e}�'�~�����/��&��aN���$mq�1o2񈈝){�y!�S����Ák�{+G�#ANf��zn�`�p�3�Ǔ0�L�Fp���|�R�����+����f���-������/����-�q�_���ן����C����?a��|���)�F�j�2����?�b����(v��%���@9����	��CY�����k��Dq
��2���[������?4��6��$b�	���%��\�I�:��%��-�C�_7K����I�u���G�������|�܏��|���\_z����u�jBx�.�W���\^SK�?ǖ�-�B��iU�ﮫ&�u���n����62:622��x�����FW�,f�|��G�0�����bn�s�ToR¾��tl��h�&�=#�-�c����[�쓕�侹�[;7�\�\���k^�7�y�f���ij��{b&�F$�c��֖h�vS�n��Mn��c�cP�e��|i��\R�X�\�P�� �/z��
XHv)�;0j6��O&�i���T�%f#TB!������)zp�^�	�io�#7%2>[��9�/�}����n���������[���G�����Y��]nN��{y��}n��8���ϐ7w	ƣ}�G��� ��lv�P����_�����_9�/���8��2���Cٙ��#o�u���{����g������{��g��|D�\�
�����������P	�_�����^���W
J����Wc�q�������?�_)x���W�����){�ط�H�.3�	=��w��k����y�e�NΩ'��j�!��V�����������o�	�����|��퇼��3�hov��Z�@�t�!����4���:�֘�_��7�4�5:p"u�Ӽ��?K����|����d�ꆑ�vGW����w��������:�f����G�ٻ�d�+��,M[f���tU�*����Ip^&m��z=�P+�0�jҿ�(!JyM#[���G��Oռ~���!ͱ�B�2�q�+�.��-6����,V���wC��h��KA	�ʥ}�h��Pb������ӗ�(&�G��˺,z���f,F�.�Q�G0�#���D�q���#�>���>���ku�u���E����BN�<b�q"����/�Ɖ�N�����l��䣲����?�׀�����W��.j�^�����@����'<�����U�?�U����9�A�AY�������gp��K�[����};�јv��b�����l������>�!����&(�����s[?���(���-D�� ȉdɄ&M��R>������1��1��c�h)�n�+䣭�[�
y:�r�O_�{�l�V�8�����IMl���WpsR��-O7y詓[��ﷷn� �Pԩ��/��I':��L�����J�na߽��k���ʯ+ᅽ��pR���<
�q��mm�y��S9�Z�Y��}��@Vc�;��񩶪0��{0�Y�����iۮ�ܒ#-WĬ%p���jV�+%�L�)�������� č��R����	�xsh����0�]�������b۰%�i�-��Ȗd�yQ�����UBS�5�I�cʳ���ǫ�p�W�>�W1�h)�F�Κ�����`WLI���J�;J�,�=�Q�_^P+��Hz uY���~���<�Ե��!�'��������m�y�X�	Y�?��\����|�3�?!��?!�����{���1� r	���m��A�a��?�����/�%���� �ߠ����oP�쿷��ϫ��J�����~��!��φ\�?Q��fD6��=BN ��G��W�a�7P�:.�������OS���SF���������\Y���ς��?ԅ@DV��}��?d���P��vɅ�G^����L@i�ARz���m�/�_��� �����t��������?���� ������������.z���m�/����ȉ�C]D��������?��g���P��?����R��2��:6��#��۶�r��̕���	���GE.���G��C�?���.���H����[��0��t����_��H]����CF�B���(��K��Ռ2C��\�ʴ��6��%�4��IgX�^֒-,c�e�/r$�~�����Ƀ��K��������)��-����/��*4Ŧ,�r�ɔ��eIzzW�L�Z:6���wژܩ[$+�q M����4��7h��UhGl�#;ړ����	�t���Z�M��@���3[;�j��Z�9WrOp=M�kVo���V�8��[�����d�F{P^�_u>�{���sF����T���Y�<����?t�A�!�(��������n�<�?��������MZ��zzLLD��F!.f0�[����%~Ֆ;{����Ѫ=o���n^���6j2ذ���G�u�T�ow|�^4�m��UM���c$��ۥ:v�9���x�B�T�I����|��E�E������glԿ�����/d@��A��������DH.�?�����`�e�7��=����_�eGA�mO�Y��#W�>o�t�_m����ϧXk�L�|}%~e���۰��m�b�덻,I���,:���7��Ѽ���_�ø0��qaˇ�5�N�/'&�W�l:R����Z��E���*��q:l���+�)0g���~�5̫�G[�?���&;�jM���4�x*��a=��+£-88'(qb����ͪZ��6�K�{a�)��W��@	�S��.Eue���[eZc��`a6��T���0-EU	Sj�c!�@H���:�fi���˻��mC&�v��	��Oo�$��B�'T�u���{�,��o���W�?�"�dA.�����Ń�gAf����e�?�����Z�i���gy�?�����n����O]����L@��/G���?�?r�g��@�o&�I��
d�d���[�1�� �����P��?�.����+�`�er�V�D
���m��B�a�d�F�a�G$����.�)��Ȅo�����s�����A�q|lU�ބ�[�E��6�6�Èkݧ���}��H+�?���z��H?�3�i�����IS>�����~��7����v�Nԯw�U��;N��B�e+sf�o����ސ�>��ٙ9���	�F7�З��0c��d�O�MM��WGi�/�G�~��~�+y��^=mQ lGZrAx>�do+(��X����b,(��Ih`��~gbW���S��p�Q�����jҖ��M�:�7�al`��M���ɰ[�(b!��Y����}+K�!����Q���0ȅ����@n��Xu[�"��߶�����d�I�_�(@�����R�����L��_P��A�/��?�?�@n�}^uS�$��߶���gI�D�H��� oM.���GƷ��J%��Q�Qݎ�F}	ǕK#�e���O5�_�������Dkolzkc3:>�)�^ ��˧��>����c�t܆F/%���{�:���~SѦ-z���b�	L��^���i�[4��A�C������7�e�|q����I & K� ~/�qOP�qc]X���Хa_���)s��ͷ�(��ZX޻�=Yֻ�"�ayӒ�C����
{M�,b���s\A�&T����w��0����+�@��L@n�}ZuK�&��߶���/RW�?A�� ?�ϔ�Њ�eq���K�9/�:m���1:��M����R�Ej<iY�a�<g�K<=縏�[ݿ?3y��k�B�6���?���;�[��3�?a#�<��F-G�~8��ڪ���Ө\x^��X8z�h���Z5��"���Z�1y�*�·������*w*9tayv��9���|\'f�jY��%�C.����|-y����':����"P����C��:r��������`��n��$��:~���w��bY�;�*s�+F/Ŗ�o=D�ݝ�;Qw���q}��n��-��~�i<�\fMH1������;!�#^��b~l��]�!�U3j˺��<�#:k/�xZ��������|���_,�@����C�����/��B�A��A������r�l@4���c�"�����7N�?[�l�=,����E�r9��[ҽ����O9 ?���c9 ��B /s 
+;�i�*m5�[��/�V����NӍբf��-*1��؊(�Y���ן�Ŧ�V�ub���ᇪ^�J�Bk��KI\��4���5!�w��<��Z�F<��.��`(�aM�����ص������	{��K%ٍ��Z�*�Nȶ��p"p����d���7�D)9O$7�j6Q׆�~iHO���m���"�U�@��"Q��4���͖/?�O��]r*=�k{vlYˋ��x��5��(GnO���ƈVz�>�����Q�i����߭�/�<}�����u}�7��d�����tw��8w����?3�"�{��?�����M���"�&�=E�(��aP��3�`���Cz�;?�,gm��ӝ�>�
r�1��w�.�w����~���������t��QZh�k��%fr�O^�8�1�c���J����|>�o�k���)�j�[����}�7��(��*����4�����o�E�K�Z�����Ճឋ[NF�^�O�7µ�:}b6�;�Ќ�;s���bF��lN#'}�LL�I��ٹ�&����#ˁ����č]����N���G���>�{�ܘ��d��߽�E������'U����_�������q?�'���b�o�%9���>=����ߧ���DER8o�����/��?n���b�f��w���c-iW����7��9�� ??Nx��OW���Zrx�:7}�ǋD����:���y>}�ĝ0ܙ������ǁҬ����^kA�I�n����`������\��W,\����[��;��K|���5'�`�o�y�6��������q>ĝ�_�O�d"�_s�܄��s��=�5�OOV���N)i�q��U�%7���U?v����f�#�[5E~��.N"M`؅�h��.����޽�a�����__�S7��������M�Q                           �%���� � 